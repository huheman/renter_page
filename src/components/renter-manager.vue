<template>
<div class='baseDiv'>
    <div class='buttonDiv'>
        <ButtonGroup class='buttionGroup'>
            <Button icon='md-add' type="primary" @click='createRenter' shape='circle'>创建住户</Button>
            <Button icon='ios-apps' @click='toRoomPage()' shape='circle'>所有房间</Button>
        </ButtonGroup>
    </div>
    <div class='baseTable'>
        <Table class='table' :columns='columns' :data='data' >
            <template slot="gender" slot-scope="{row,index}">
                {{row.gender?'男':'女'}}
            </template>
            <template slot="action" slot-scope="{row,index}">
                <a @click.prevent='modifyRenter(row)'><Icon type="md-build" /> 修改</a>
                <Divider type='vertical'></Divider>
                <a @click.prevent='deleteRenter(row)'><Icon type="md-close" />删除</a>
            </template>
        </Table>
        <Page style="margin: 10px auto" :total="total" show-total show-sizer @on-change='handlePageChange' @on-page-size-change='handlePageSizeChange'></Page>
    </div>
    <RenterModal ref='renterModal' @onPostSuccess='onPostSuccess'>
    </RenterModal>
</div>
</template>

<script lang='ts'>
import {Component,Vue} from 'vue-property-decorator'
import axios from '@/plugins/axios'
import {toRoomPage} from '@/assets/api'
import RenterModal from '@/components/renter-modal.vue'
@Component({components:{
    RenterModal
}})
export default class App extends Vue {
    private columns=[
        {
            type:"index",
            title:'#',
            width:'50'
        },
        {
            title: '住户姓名',
            key: 'name',
        },
        {
            title:'性别',
            slot: 'gender',
        },
        {
            title: '年龄',
            key: 'age'
        },
        {
            title:'手机号码',
            key: 'mobile'
        },
        {
            title:'微信号',
            key: 'wechatNum'
        },
        {
            title: '所在房间',
            key: 'roomName'
        },
        {
            title:'操作',
            slot:'action',
            width: '160'
        }
    ]
    private data = []
    private total = 0
    private conditionToPost:any
    get renterModal(){
        let target:any = this.$refs.renterModal
        return target
    }
    private handlePageChange(currentPage){
        this.conditionToPost.currentPage = currentPage
        this.getRenterByPage()
    }

    private handlePageSizeChange(pageSize){
        this.conditionToPost.pageSize = pageSize
        this.getRenterByPage()
    }

    private getRenterByPage(){
        axios.get("/rentermodel/renter",{params:this.conditionToPost}).then(resp => {
            this.data = resp.data.data.list
            this.total = resp.data.data.totalCount
        })
    }

    private toRoomPage = toRoomPage

    mounted(){
        this.getRenterByPage()
    }

    private createRenter(){
        this.renterModal.init()
    }

    private modifyRenter(row){
        this.renterModal.setRenterInModal(row)
    }

    private deleteRenter(row){
        this.$Modal.confirm({
            content: '是否要删除住户'+row.name,
            onOk: ()=>{
                axios({
                    method: 'delete',
                    url: '/rentermodel/renter',
                    params:{
                        renterId:row.id
                    }
                }).then(resp => {
                    this.getRenterByPage()
                })
            }
        })
    }

    private onPostSuccess(){
        this.getRenterByPage()
    }
    
}
</script>

<style>

</style>