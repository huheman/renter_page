<template>
  <div>
      <Table :columns='columns' :data='data' >
            <template slot="rooms" slot-scope="{row,index}">
                <div v-if="row.roomList.length > 0">
                    {{row.roomList.length+'间:'}}
                    <span v-for="room in row.roomList" :key="room.id" >
                        <Poptip transfer v-if="room.roomStatus==1"  trigger="hover" title="住户信息：" @on-popper-show='findRenterList(room.id)'>
                            <div slot='content' style="position: relative;overflow: hidden;">
                                <Spin size="large" fix v-if="spinShow"></Spin>
                            <p v-for="renter in currentRenterList"  :key="renter.id" style="text-align:center">
                                {{renter.name + '  ， '+ renter.age}}岁{{' ， '+(renter.gender?'男':'女')}}
                            </p>
                            </div>
                            <Tag color='green'>{{room.roomName}}</Tag>
                        </Poptip>
                        
                        <Tag color='red' v-else   >{{room.roomName}}</Tag>
                    </span>
                    
                </div>
                <div  v-else>暂未有房间应用此模板</div>
                
            </template>
            <template slot='charge' slot-scope="{row,index}">
                <Tag :color='translateUnitCodeToString(row)[1]'>{{row.amountPerUnit +' 元 / '+translateUnitCodeToString(row)[0]}}</Tag>
            </template>
            <template slot="action" slot-scope="{row,index}">
                <a @click.prevent='$emit("modifyChargeTemplate",row)'><Icon type="md-build" /> 修改</a>
                <Divider type='vertical'></Divider>
                <a @click.prevent='deleteChargeTemplate(row)'><Icon type="md-close" />删除</a>
            </template>
            <template slot="status" slot-scope="{row,index}" >
                <Button size='small' type='success'  v-if="row.isDisabled == 0" icon='md-bulb' @click.prevent='changeDisabled(row,1)'>生效中</Button>
                <Button size='small' type='error'  icon="md-close-circle" v-else @click.prevent='changeDisabled(row,0)'>失效中</Button>
            </template>
        </Table>
        <Page style="margin: 10px auto" :total="total" show-total show-sizer @on-change='handlePageChange' @on-page-size-change='handlePageSizeChange'></Page>
  </div>
</template>

<script lang='ts'>
import {Component,Vue} from 'vue-property-decorator'
import axios from '@/plugins/axios'
import {translateUnitCodeToString} from '@/assets/api'
@Component({components:{
}})
export default class App extends Vue {
    private columns = [
        {
            type:'index',
            title:'#',
            width:'50'
        },
        {
            title: '费用模板名称',
            key: 'name'
        },
        {
            title: '费用',
            slot: 'charge'
        },
        {
            title: '应用房间数',
            slot:'rooms'
        },
        {
            title: '状态',
            slot: 'status'
        },
        {
            title: '备注',
            key: 'desc'
        },
        {
            title: '操作',
            slot: 'action',
            width: '190'
        }
    ]
    private data = []
    private conditionToPost:any={}
    private total = 0;
    private currentRenterList=[
    ]
    private spinShow = true;

    private changeDisabled(chargeTemplate,disabledCode){
        let url = '/chargemodel/chargeTemplate/changeDisabledStatus/'+chargeTemplate.id+"/"+disabledCode
        console.log(url)
        axios({
            url:url,
            method: 'get',
            }).then(resp =>{
            this.getchargeTemplateByPage()
        })
    }

    private deleteChargeTemplate(chargeTemplate){
        this.$Modal.confirm({
            content: '是否要删除费用模板'+chargeTemplate.name,
            onOk: ()=>{
                axios({
                    method: 'delete',
                    url: '/chargemodel/chargeTemplate',
                    params:{
                        chargeTemplateId:chargeTemplate.id
                    }
                }).then(resp => {
                    this.getchargeTemplateByPage()
                })
            }
        })
    }

    private translateUnitCodeToString= translateUnitCodeToString

    private handlePageChange(currentPage){
        this.conditionToPost.currentPage = currentPage
        this.getchargeTemplateByPage()
    }

    private handlePageSizeChange(pageSize){
        this.conditionToPost.pageSize = pageSize
        this.getchargeTemplateByPage()
    }

    private getchargeTemplateByPage(){
        axios.get("/chargemodel/chargeTemplate",{params:this.conditionToPost}).then(resp => {
            this.data = resp.data.data.list
            this.total = resp.data.data.totalCount
        })
    }

    private findRenterList(roomId){
        this.spinShow =true
        axios.get("/rentermodel/renter/baseRenterDTO/"+roomId).then(resp => {
            this.currentRenterList = resp.data.data
            this.spinShow = false
        })
    }

    mounted(){
        this.getchargeTemplateByPage()
    }
}
</script>

<style>

</style>