<template>
  <div class="baseDiv">
    <div class="baseTable">
      <Tabs class="table" v-model="currentPane">
        <TabPane name="total" label="全部房间">
          <RoomTable ref="total" :totalTemplate='totalTemplate'  @toModifyRoomInfo="modifyRoom" @moveIn='moveIn' @moveOut='moveOut' @toModifyBillInfo="showModifyDegreeModal"></RoomTable>
        </TabPane>
        <TabPane
          :name='"group"+roomGroup.id'
          v-for="roomGroup in allGroups"
          :key="roomGroup.id"
          :label="roomGroup.groupName">
          <RoomTable :ref='"group"+roomGroup.id' :totalTemplate='totalTemplate' :roomGroupIdList="[roomGroup.id]" @toModify="modifyRoom"  @moveIn='moveIn' @moveOut='moveOut'></RoomTable>
        </TabPane>
        <ButtonGroup slot="extra" shape="circle">
          <Button icon="md-add" type="primary" @click="createRoom">创建房间</Button>
          <Button icon="ios-albums" @click="createNote">创建备注</Button>
          <Button icon="md-bookmarks" @click="toGroup()">所有组别</Button>
        </ButtonGroup>
      </Tabs>
    </div>
    <!-- 房间读数编辑模态框 -->
    <DegreeModal ref="degreeModal" :totalTemplate='totalTemplate'></DegreeModal>
    <!--房间信息编辑模态框-->
    <RoomPropertiesModal ref="roomPropertiesModal" :allGroups='allGroups' :renterList='renterList' @onPostRoom='reflashCurrentTable'></RoomPropertiesModal>
    <!-- 入住表格模态框 -->
    <MoveInModal ref="moveInModal"  :renterList='renterList' @newRenter='newRenter' @hasMoveIn='reflashCurrentTable();fetchAllRenterList()' @modifyDegrees='showModifyDegreeModal' ></MoveInModal>
    <!-- 搬出表格模态框 -->
    <MoveOutModal ref="moveOutModal"  :totalTemplate='totalTemplate' :renterList='renterList' @hasMoveOut='reflashCurrentTable()'></MoveOutModal>
    <!-- 新建租户模态框 -->
    <RenterModal ref='renterModal' @onPostSuccess='onNewRenterPostSuccess'></RenterModal>
  </div>
</template>

<script lang='ts'>
import { Component, Vue, Watch } from "vue-property-decorator"
import axios from "@/plugins/axios"
import RoomTable from "@/components/page-room-table.vue"
import _axios from '@/plugins/axios'
import {toGroup} from '@/assets/api'
import RenterModal from "@/components/renter-modal.vue"
import RoomPropertiesModal from '@/components/room-properties-modal.vue'
import MoveInModal from '@/components/move-in-modal.vue'
import DegreeModal from '@/components/degree-modify-modal.vue'
import MoveOutModal from '@/components/move-out-modal.vue'
@Component({
  components: {
    RoomTable,
    RenterModal,
    RoomPropertiesModal,
    MoveInModal,
    DegreeModal,
    MoveOutModal
  }
})
export default class App extends Vue {
  private currentPane:any = 'total'; // 当前激活组件，默认是total
  private allGroups = []; // 所有组别
  private renterList = [];
  private totalTemplate=[];
  /**获取renterModal */
  get renterModal(){
        let target:any = this.$refs.renterModal
        return target
    }

  get degreeModal(){
    let target:any = this.$refs.degreeModal
    return target
  }

  get roomPropertiesModal(){
    let target:any = this.$refs.roomPropertiesModal
    return target
  }

  get moveInModal(){
    let target:any = this.$refs.moveInModal
    return target
  }

  get moveOutModal(){
    let target:any = this.$refs.moveOutModal
    return target
  }
  mounted() {
    // 获取所有房间组别
    this.fetchAllRoomGroup(()=>{
      let urlPaneName = this.$route.query.currentPane
      if(urlPaneName){
        // 如果url有值，则改变urlpaneName就好，会自动调用watch信息
        this.currentPane = urlPaneName
      }else{
        // 刷新当前组别表格，
        this.reflashCurrentTable();
      }
    });
    this.fetchAllRenterList()
    this.fetchAllChargeTemplate()
  }

  private fetchAllChargeTemplate(){
    this.$axios.get("/chargemodel/chargeTemplate/listAll").then(resp=>{
      this.totalTemplate = resp.data.data
      this.roomPropertiesModal.setUpChargeTemplateInTransfer(this.totalTemplate)
    })
  }

  
  /**通过当前激活页面拿到激活的roomTable */
  get currentRoomTable():any{
    let target
    if (this.currentPane == "total") {
      target = this.$refs[this.currentPane];
    } else {
      target = this.$refs[this.currentPane][0];
    }
    return target
  }

  /**获取所有房间组别信息 */
  private fetchAllRoomGroup(fun:any) {
    this.$axios.get("/roommodel/roomgroup").then(resp => {
      this.allGroups = resp.data.data;
      if (!this.allGroups) {
        this.allGroups = []
      }
      if(fun){
        this.$nextTick(fun)
      }
    });
  }

  private toGroup = toGroup

  /** 创建房间 */
  private createRoom(){
    this.roomPropertiesModal.createRoom(this.currentRoomTable.roomGroupIdList)
  }

  /** 修改房间 */
  private modifyRoom(room){
    this.roomPropertiesModal.modifyRoom(room)
  }

  /**监控当前标签改变 */
  @Watch("currentPane")
  private handleTabsClicked(to, from) {
    // 一旦改变了就刷新当前标签
    this.reflashCurrentTable();
  }

  /**刷新当前标签的表格 */
  private reflashCurrentTable() {
    this.currentRoomTable.getRoomMsgByPage();
  }

  /** 打开住户模态框，创建新住户 */
  private newRenter(){
    this.renterModal.init()
  }
  

  /**获取所有租户的信息 */
  private fetchAllRenterList(){
    this.$axios.get("/rentermodel/renter/listAll").then(resp=>{
      this.renterList = resp.data.data
      if(!this.renterList){
        this.renterList = []
      }
    })
  }

  /** 新建备忘 */
  private createNote() {
  }

  /**当新增住户完成 */
  private onNewRenterPostSuccess(){
    this.fetchAllRenterList()
  }

  private moveIn(roomToMoveIn){
    this.moveInModal.setRoomToMoveIn(roomToMoveIn)
  }

  private showModifyDegreeModal(roomToModify){
    this.degreeModal.setRoomToModify(roomToModify)
  }

  private moveOut(roomToMoveOut){
    this.moveOutModal.setRoomToMoveOut(roomToMoveOut)
  }
}
</script>

<style>
</style>