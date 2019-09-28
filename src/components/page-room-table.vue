<template>
  <Table :columns='columns' :data='data'>
      <template slot-scope='{row}' slot='status'>
          <Tag v-if="row.roomStatus == 1" color="green">租用中</Tag>
          <Tag v-if="row.roomStatus == 0" color="red">空置中</Tag>
      </template>
      <template slot='action' slot-scope="{row}">
          <a @click.prevent='$emit("toModify",row)'>修改</a>
          <Divider type='vertical'></Divider>
          <a @click.prevent='toDelete'>删除</a>
      </template>
  </Table>
</template>
<script lang='ts'>
import {Component,Vue, Prop, Watch} from 'vue-property-decorator'
import _axios from '../plugins/axios';
@Component({components:{
}})
export default class App extends Vue {
    @Prop() private roomGroupIdList:Number
    private conditionToPost:any = {};
    private columns = [
        {
            type:'index',
            title:'#',
            width:'40'
        },
        {
            title: '房间名称',
            key: 'roomName'
        },
        {
            title: '房间状态',
            slot:'status'
        },
        {
            title: '最近账单日状态',
        },
        {
            title: '费用模板',
        },
        {
            title: '操作',
            slot: 'action'
        }
    ]
    private data = []
    public getRoomMsgByPage(){
        // 创建查询对象
        this.conditionToPost.roomGroupIdList = this.roomGroupIdList
        // 把查询对象传给后台，获取对应的房间列表
        _axios.get("/api/roommodel/room",{params:this.conditionToPost}).then(resp => {
            this.data = resp.data.data.list
        })
    }
    mounted(){
    }
}
</script>

<style>

</style>