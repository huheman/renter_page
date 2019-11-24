<template>
  <div>
    <Modal
      v-model="modalShow"
      :title="modalTitle"
      :loading="modalLoading"
      width="535"
      @on-ok="postRoom"
    >
      <Form ref="roomForm" :model="roomInModal" :label-width="80">
        <FormItem label="房间名称" required prop="roomName">
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
        <FormItem v-if="moveInableRenterList.length>0" label="住户">
          <Select
            v-model="roomInModal.renterIdList"
            filterable
            clearable
            placeholder="房间入住应从业务系统发起入住流程"
            multiple
          >
            <Option v-for="item in moveInableRenterList" :value="item.id" :key="item.id">{{ item.name }}</Option>
          </Select>
        </FormItem>
        <FormItem label="费用模板">
          <Transfer
            :titles="titles"
            :data="totalTemplateInTransfer"
            :target-keys="roomInModal.chargeTemplateIdList"
            filterable
            @on-change="handleTransferChange"
          ></Transfer>
        </FormItem>
      </Form>
    </Modal>
  </div>
</template>

<script lang='ts'>
import { Component, Vue, Prop, Emit } from "vue-property-decorator";
import axios from "../plugins/axios";
@Component({ components: {} })
export default class App extends Vue {
  private modalShow = false; // 模态框是否显示
  private modalTitle = ""; // 模态框的提示
  private modalLoading = true; // 点击确定后模态框是否消失
  private roomInModal: any = {}; // 模态框中的房间信息
  private titles = ["所有模板", "已选模板"];
  private totalTemplateInTransfer = [];
  @Prop() private allGroups;
  @Prop() private renterList;
  private handleTransferChange(newTargetKeys: []) {
    this.roomInModal.chargeTemplateIdList = newTargetKeys;
  }

  /**新建房间，要初始化模态框 */
  public createRoom(roomGroupIdList) {
    this.modalTitle = "新建房间";
    this.roomInModal = {
      roomGroupIdList: roomGroupIdList,
      renter: {},
      renterIdList: [],
      chargeTemplateIdList: []
    };
    this.modalShow = true;
  }

  public modifyRoom(room) {
    this.modalTitle = "修改房间信息";
    this.roomInModal = JSON.parse(JSON.stringify(room));
    this.modalShow = true;
  }

  /**把房间的改动传给服务器 */
  private postRoom() {
    this.$axios.post("/roommodel/room", this.roomInModal).then(resp => {
      // 先把loading停了先
      this.modalLoading = false;
      this.$nextTick(() => {
        this.modalLoading = true;
      });
      if (resp.data.resultFlag == 20000) {
        this.$Message.success("保存房间成功");
        this.onPostRoom();
        this.modalShow = false;
      }
    });
  }
  @Emit("onPostRoom") private onPostRoom() {}

  get moveInableRenterList() {
    return this.renterList.filter(renter => {
      return !renter.roomId  || renter.roomId === this.roomInModal.id;
    });
  }
  public setUpChargeTemplateInTransfer(totalTemplate) {
    for (let chargeTemplate of totalTemplate) {
      this.totalTemplateInTransfer.push({
        key: chargeTemplate.id,
        label: chargeTemplate.name,
        disabled: chargeTemplate.isDisabled == 1
      });
    }
  }
}
</script>

<style>
</style>