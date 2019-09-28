<template>
    <div>
  <Table :columns='columns' :data='data'>
      <template  slot-scope="{row}" slot="roomName">
        <Tooltip  v-if="row.roomDesc" trigger="hover"  :content="row.roomDesc" placement="top-start">
            <a style="cursor:default" >{{row.roomName}}</a>
        </Tooltip>
        <p style="cursor:default" v-else>{{row.roomName}}</p>
      </template>
      <template slot-scope='{row}' slot='status'>
          <Tag v-if="row.roomStatus == 1" color="green">租用中</Tag>
          <Tag v-if="row.roomStatus == 0" color="red">空置中</Tag>
      </template>
      <template slot='action' slot-scope="{row,index}">
          <a @click.prevent='$emit("toModify",row)'><Icon type="md-build" /> 修改</a>
          <Divider type='vertical'></Divider>
          <a @click.prevent='toDelete(index)'><Icon type="md-close" />删除</a>
      </template>
  </Table>
  <Page style="margin: 10px auto" :total="total" show-total show-sizer @on-change='handlePageChange' @on-page-size-change='handlePageSizeChange'></Page>
    </div>
</template>
<script lang='ts'>
import {Component,Vue, Prop, Watch} from 'vue-property-decorator'
import _axios from '../plugins/axios';
@Component({components:{
}})
export default class App extends Vue {
    @Prop() private roomGroupIdList:[Number]
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
        },
        {
            title: '操作',
            slot: 'action',
            width: '160'
        }
    ]
    private data = []
    private total = 0
    public getRoomMsgByPage(){
        // 创建查询对象
        if(this.roomGroupIdList)
            this.conditionToPost.roomGroupIdList = this.roomGroupIdList.join(',')
        // 把查询对象传给后台，获取对应的房间列表
        _axios.get("/api/roommodel/room",{params:this.conditionToPost}).then(resp => {
            this.data = resp.data.data.list
            this.total = resp.data.data.totalCount
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
            _axios({
                method: 'delete',
                url:'/api/roommodel/room',
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
}
</script>

<style>

</style>