<template>
  <div>
    <div class="baseTable">
      <Tabs class="table" v-model="currentPane">
        <TabPane name="total" label="全部房间">
          <RoomTable ref="total"  @toModify="modifyRoom"></RoomTable>
        </TabPane>
        <TabPane
          :name='"group"+roomGroup.id'
          v-for="roomGroup in allGroups"
          :key="roomGroup.id"
          :label="roomGroup.groupName"
        >
          <RoomTable :ref='"group"+roomGroup.id' :roomGroupIdList="roomGroup.id" @toModify="modifyRoom"></RoomTable>
        </TabPane>
        <ButtonGroup slot="extra" shape="circle">
          <Button icon="md-add" type="primary" @click="createRoom">创建房间</Button>
          <Button icon="ios-albums-outline" @click="createNote">创建备注</Button>
        </ButtonGroup>
      </Tabs>
    </div>

    <!--房间信息编辑模态框-->
    <Modal
      v-model="modalShow"
      :title="modalTitle"
      :loading="modalLoading"
      width="535"
      @on-ok="postRoom"
    >
      <Form :model="roomInModal" :label-width="80">
        <FormItem label="房间名称" required>
          <Input v-model="roomInModal.roomName" placeholder="请输入房间名称"></Input>
        </FormItem>
        <FormItem label="房间描述">
          <Input
            type="textarea"
            :autosize="{minRows: 2,maxRows: 5}"
            v-model="roomInModal.roomDesc"
            placeholder="请输入房间的介绍"
          ></Input>
        </FormItem>
        <FormItem label="所在组别">
          <Select v-model="roomInModal.roomGroupIdList" filterable multiple>
            <Option v-for="item in allGroups" :value="item.id" :key="item.id">{{ item.groupName }}</Option>
          </Select>
        </FormItem>
        <!--
            <FormItem label="住户">
              <Select v-model="roomInModal.renter.id" filterable>
                <Option v-for="item in cityList" :value="item.id" :key="item.id">{{ item.name }}</Option>
              </Select>
            </FormItem>
            <FormItem label="费用模板" >
                <Transfer>
                    
                </Transfer>
            </FormItem>
        -->
      </Form>
    </Modal>
  </div>
</template>

<script lang='ts'>
import { Component, Vue, Watch } from "vue-property-decorator";
import axios from "@/plugins/axios";
import RoomTable from "@/components/page-room-table.vue";
import _axios from '@/plugins/axios';
@Component({
  components: {
    RoomTable
  }
})
export default class App extends Vue {
  private currentPane: string = "total"; // 当前激活组件
  private allGroups = []; // 所有组别
  private allRenter = []; // 所有住户
  private modalShow = false; // 模态框是否显示
  private modalTitle = ""; // 模态框的提示
  private modalLoading = true; // 点击确定后模态框是否消失
  private roomInModal = { roomGroupIdList: [] }; // 模态框中的房间信息
  mounted() {
    // 获取所有房间组别
    this.fetchAllRoomGroup();
    // 刷新当前组别表格
    this.reflashCurrentTable();
  }

  /**获取所有房间组别信息 */
  private fetchAllRoomGroup() {
    axios.get("/api/roommodel/roomgroup").then(resp => {
      this.allGroups = resp.data.data;
      if (!this.allGroups) {
        this.allGroups = [];
      }
    });
  }

  /**监控当前标签改变 */
  @Watch("currentPane")
  private handleTabsClicked(to, from) {
    // 一旦改变了就刷新当前标签
    this.reflashCurrentTable();
  }

  /**刷新当前标签的表格 */
  private reflashCurrentTable() {
    let target;
    if (this.currentPane == "total") {
      target = this.$refs[this.currentPane];
    } else {
      target = this.$refs[this.currentPane][0];
    }
    target.getRoomMsgByPage();
  }

  /**新建房间，要初始化模态框 */
  private createRoom() {
    this.modalTitle = "新建房间";
    this.roomInModal = { roomGroupIdList: [] };
    this.modalShow = true;
  }

  private modifyRoom(room) {
    this.modalTitle = "修改房间信息";
    this.roomInModal = room
    // 获取房间对应的楼层信息
    _axios.get("/api/roommodel/room/getRoomGroupId",{params:{
      roomId: room.id
    }}).then(resp => {
      this.roomInModal.roomGroupIdList = resp.data.data
      this.modalShow = true
    })
    
  }

  private createNote() {}

  /**把房间的改动传给服务器 */
  private postRoom() {
    axios.post("/api/roommodel/room", this.roomInModal).then(resp => {
      // 先把loading停了先
      this.modalLoading = false;
      this.$nextTick(() => {
        this.modalLoading = true;
      });
      if (resp.data.resultFlag == 20000) {
        this.$Message.success("保存房间成功");
        this.reflashCurrentTable();
        this.modalShow = false;
      }
    });
  }
}
</script>

<style>
</style>