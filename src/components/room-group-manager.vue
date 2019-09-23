<template>
  <div>
    <div class='buttonDiv'>
        <ButtonGroup class='buttionGroup'>
            <Button icon='md-add' type="primary" @click='createGroup'>创建组别</Button>
        </ButtonGroup>
    </div>
    <div class='baseTable'>
        <Table class="table" :columns="column" :data="tableData">
            <template slot-scope="{row}" slot = "groupType">
                {{groupTypes[row.groupType].title}}
            </template>
            <template slot-scope="{row}" slot="roomCount">
                {{row.roomIdList.length+' 间'}}
            </template>
            <template slot-scope="{row,index}" slot="name">
                <Tooltip  v-if="row.groupDesc" trigger="hover"  :content="row.groupDesc" placement="top-start">
                    <a @click.prevent='toRoomPage(index)'>{{row.groupName}}</a>
                </Tooltip >
                 <a v-else @click.prevent='toRoomPage(index)'>{{row.groupName}}</a>
            </template>
            <template slot-scope="{row,index}" slot='action'>
                <a type="text"  @click.prevent='toModify(index)'><Icon type="md-build" /> 修改</a>
                <Divider type="vertical" />
                <a type="text"  @click.prevent='toDelete(index)'><Icon type="md-close" /> 删除</a>
            </template>
        </Table>
    </div>
    <Modal
        v-model="modalShow"
        :title="modalTitle"
        :loading="modalLoading"
        @on-ok="postGroup">
        <Form :model="groupInModal" :label-width="80" >
            <Row :gutter='8'>
                <Col :span='12'>
                    <FormItem label="组名" required >
                        <Input v-model="groupInModal.groupName" placeholder="请输入组名"></Input>
                    </FormItem>
                </Col>
                <Col :span='12'>
                    <FormItem label="类型" required >
                        <Select v-model="groupInModal.groupType">
                            <Option v-for="groupType in groupTypes" :key="groupType.key" :value="groupType.key">{{groupType.title}}</Option>
                        </Select>
                    </FormItem>
                </Col>
            </Row>
            <FormItem label="组别介绍" >
                <Input type="textarea" :autosize="{minRows: 2,maxRows: 5}" v-model="groupInModal.groupDesc" placeholder="请输入组的描述"></Input>
            </FormItem>
            <Transfer
                :titles = 'titles'
                :data="transferTotalData"
                :target-keys="groupInModal.roomIdList"
                filterable
                @on-change="handleTransferChange">
            </Transfer>
        </Form>
    </Modal>
  </div>
</template>

<script lang="ts">
import { Component, Vue } from "vue-property-decorator";
import {Table} from 'iview';
import '@/assets/base.css';
import axios from '@/plugins/axios';



@Component
export default class RoomGroup extends Vue {
  private column = [
    {
      title: "组别名称",
      slot: 'name'
    },
    {
      title: "组类型",
      slot: "groupType"
    },
    {
      title: "房间数量",
      slot: "roomCount"
    },
    {
      title: "操作",
      slot: 'action'
    }
  ];
  private groupTypes = [
      {
          key: 0,
          title: '住宅'
      },
      {
          key: 1,
          title: '厂房'
      },
      {
          key: 2,
          title: '其他'
      },
  ];
  private tableData = [];
  private transferTotalData=[
      {
          key: 1,
          label: '204'
      },
      {
          key:2,
          label:'205'
      },
      {
          key:3,
          label:'206'
      },
      {
          key:4,
          label:'207'
      }
  ];
  private modalTitle=''
  private groupInModal:any={roomIdList:[],groupType:0}
  private modalShow:boolean = false
  private titles = ['所有房间','当前组别房间']
  private modalLoading=true
  // 创建时期
  created(){
      this.initModal()
      this.getAllRoomGroups()
  }
  // 点击了修改连接
  private toModify(index:number){
      this.modalTitle= '修改组别'
      this.modalShow = true
      this.groupInModal = this.tableData[index]
  }

  // 点击了某个房间
  private toRoomPage(index:number){
      alert(index)
  }

  // 点击了删除链接
  private toDelete(index:number){
      this.$Modal.confirm({
          content: '是否真的要删除房间组别：'+this.tableData[index].groupName,
          onOk: () => {
            axios({
                method: 'delete',
                url:'/roomgroup',
                params:{
                    id: this.tableData[index].id
                }
            }).then(resp =>{
                this.getAllRoomGroups()
            })
          },
          
      })
  }

  // 点击了创建按钮后
  private createGroup(){
      this.initModal()
      this.modalShow = true
  }

  // 把模态框里的数据投到服务器 
  private postGroup(){
      axios.post("/roomgroup",this.groupInModal).then(resp =>{
          if(resp.data.resultFlag == 20000){
              this.$Message.success("保存成功")
              this.getAllRoomGroups()
              this.modalShow = false
          }else{
              this.modalLoading = false
          }
          // 用nextTick可以异步把modalLoading变成可loading的
          this.$nextTick(() =>{
            this.modalLoading= true
           })
      })
      
  }
  // 处理穿梭框出现变化，需手动指定selectedKey
  private handleTransferChange(newTargetKeys:[]){
      this.groupInModal.roomIdList = newTargetKeys
  }
  // 初始化模态框的数据
  private initModal(){
    this.modalTitle= '创建组别'
    this.groupInModal = {roomIdList:[],groupType:0}
  }
  // 获得所有房间组别的数据
  private getAllRoomGroups(){
     axios.get("/roomgroup").then((resp)=>{
         this.tableData = resp.data.data.list
         if(!this.tableData){
             this.tableData = []
         }
     })
  }
}
</script>

<style>
</style>