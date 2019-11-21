<template>
    <div>
  <Table :columns='columns' :data='data' :loading='loading'>
      <template  slot-scope="{row}" slot="roomName">
        <Tooltip  v-if="row.roomDesc" trigger="hover"  :content="row.roomDesc" placement="top-start">
            <a style="cursor:default" >{{row.roomName}}</a>
        </Tooltip>
        <p style="cursor:default" v-else>{{row.roomName}}</p>
      </template>
      <template slot-scope='{row}' slot='status'>
        <Poptip transfer v-if="row.renterList.length > 0"  trigger="hover" title="住户信息：">
            <div slot='content' style="position: relative;overflow: hidden;">
            <p v-for="renter in row.renterList" :key="renter.id" style="text-align:center">
                {{renter.name + '  ， '+ renter.age}}岁{{' ， '+(renter.gender?'男':'女')}}
            </p>
            </div>
            <Tag  color="green">租用中</Tag>
        </Poptip>
          <Tag v-else color="red">空置中</Tag>
      </template>
      <template slot-scope='{row}' slot='chargeTemplate'>
          <ChargeTemplateTab :chargeTemplateIdList='row.chargeTemplateIdList' :totalTemplate='totalTemplate'></ChargeTemplateTab>
      </template>
      <template slot='action' slot-scope="{row,index}">
          <a @click.prevent='$emit("toModifyRoomInfo",row)'><Icon type="md-build" /> 设置房间信息</a>
          <Divider type='vertical'></Divider>
          <a @click.prevent='$emit("toModifyBillInfo",row)' v-if="row.canSetupMoveInDegree"><Icon type="logo-usd" /> 设置初始费用</a>
          <Divider type='vertical' v-if="row.canSetupMoveInDegree"></Divider>
          <a @click.prevent='toDelete(index)'><Icon type="md-close" />删除</a>
      </template>
      <template slot="roomManage" slot-scope="{row,index}">
          <div v-if="row.renterList.length > 0">
          <Button  type='default' @click="moveOut(row)">退房</Button>
          </div>
          <Button v-else type='info'  @click="moveIn(row)">入住</Button>
      </template>
  </Table>
  <Page style="margin: 10px auto" :total="total" show-total show-sizer @on-change='handlePageChange' @on-page-size-change='handlePageSizeChange'></Page>
    </div>
    
</template>
<script lang='ts'>
import {Component,Vue, Prop, Watch,Emit} from 'vue-property-decorator'
import ChargeTemplateTab from "@/components/charge-template-tab.vue";

@Component({components:{
    ChargeTemplateTab
}})
export default class App extends Vue {
    @Prop() private roomGroupIdList:[Number]
    @Prop() private totalTemplate:[any]
    private conditionToPost:any = {};
    private columns = [
        {
            type:'index',
            title:'#',
            width:'50'
        },
        {
            title: '房间名称',
            slot: 'roomName'
        },
        {
            title: '房间状态',
            slot:'status'
        },
        {
            title: '账单状态',
        },
        {
            title: '费用模板',
            slot: 'chargeTemplate'
        },
        {
            title: '房间管理',
            slot: 'roomManage'
        },
        {
            title: '其他',
            slot: 'action',
        }
    ]
    private loading = false;
    private spinShow =true // 是否显示loading
    private data = []
    private total = 0
    public getRoomMsgByPage(){
        this.loading = true
        // 创建查询对象
        if(this.roomGroupIdList)
            this.conditionToPost.roomGroupIdList = this.roomGroupIdList.join(',')
        // 把查询对象传给后台，获取对应的房间列表
        this.$axios.get("/roommodel/room",{params:this.conditionToPost}).then(resp => {
            this.loading = false
            this.data = resp.data.data.list
            this.total = resp.data.data.totalCount
            for (const room of this.data) {
                this.$axios.get("/chargemodel/chargeTemplate/canSetupMoveInRoomDegrees",{params:{roomId: room.id}}).then(resp => {
                    this.$set(room,'canSetupMoveInDegree',resp.data.data)
                })
            }
        })
    }
    handlePageChange(page){
        this.conditionToPost.currentPage = page;
        this.getRoomMsgByPage();
    }

    handlePageSizeChange(pageSize){
        this.conditionToPost.pageSize = pageSize
        this.getRoomMsgByPage();
    }

    private toDelete(index:number){
        this.$Modal.confirm({
          content: '是否真的要删除房间：'+this.data[index].roomName,
          onOk: () => {
            this.$axios({
                method: 'delete',
                url:'/roommodel/room',
                params:{
                    roomId: this.data[index].id
                }
            }).then(resp =>{
                this.getRoomMsgByPage()
            })
          },
      })
    }

    mounted(){
    }

    // 入住房间
    @Emit("moveIn") private moveIn(row){
        return row
    }

    // 退房
    @Emit("moveOut") private moveOut(row){
        return row
    }
}
</script>

<style>

</style>