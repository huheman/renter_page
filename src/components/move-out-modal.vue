<template>
  <Modal v-model="modalShow"
      :title="modalTitle"
      :loading="modalLoading"
      width="550"
      @on-ok="moveOut">
      <Form :label-width="100">
        <Row >
          <Col span="12">
            <FormItem label="房间名" >
              <Input readonly :value="roomToMoveOut.roomName"/>
            </FormItem>
          </Col>
          <Col span='12'>
            <FormItem label="押金" >
              <InputNumber readonly
            v-model="roomToPost.deposit"
            :formatter="value => `￥ ${value}`"
            :step = '0.1'
            :parser="value => value.replace(/￥ /g, '')"
            style="width:100%"
            placeholder="请输入押金">
            </InputNumber>
            </FormItem>
          </col>
         </Row>
         

        <Row>
          <Col span="12">
            <FormItem label="入住人"  >
              <Input readonly :value="renterNameList"/>
            </FormItem>
          </Col>
          <Col span="12">
             <FormItem label="居住时长" >
                 <Input readonly :value="howLong"/>
            </FormItem>
          </Col>
         </Row>
         <Row >
          <Col span="12">
            <FormItem label="入住日期" >
              <DatePicker readonly :value='roomToPost.moveInDate' ></DatePicker>
            </FormItem>
          </Col>
          <Col span='12'>
          <FormItem label="搬出日期"  >
              <DatePicker v-model="roomToPost.moveOutDate" :clearable="false" ></DatePicker>
            </FormItem>
          </col>
          </Row>
      </Form>
      <DegreeModifyDiv ref="degreeModifyDiv" :totalTemplate='totalTemplate' :isMoveOut='true'/>
  </Modal>
</template>

<script lang='ts'>
import {Component,Vue,Prop, Emit, Watch} from 'vue-property-decorator'
import DegreeModifyDiv from '@/components/degree-modify-div.vue'
import moment from 'moment'
import axios from '@/plugins/axios';
@Component({components:{
    DegreeModifyDiv
}})
export default class App extends Vue {
  @Prop() private renterList!:Array<any>
  @Prop() private totalTemplate
  private roomToMoveOut:any={}
  private roomToPost:any={}
  private modalShow:boolean = false
  private modalTitle:string = '房间搬出'
  private modalLoading:boolean = true

  get degreeModifyDiv(){
      let target:any = this.$refs.degreeModifyDiv
      return target
    }

  get renterNameList(){
    if (this.roomToMoveOut.renterList){
      return this.roomToMoveOut.renterList.map(renter => {return renter.name}).join(",")
    }
    return ""
  }

  get howLong(){
    if (this.roomToPost.moveInDate && this.roomToPost.moveOutDate){
      let dura = moment(this.roomToPost.moveOutDate).diff(moment(this.roomToPost.moveInDate))
      if (dura <0) return '搬出时间不能小于入住时间'
      let duration = moment.duration(dura)
      let durationStr =  (duration.years() ?  duration.years() + '年' :'') + (duration.months() ? duration.months() + '个月' : '') + (duration.days() ?duration.days() + '天':'')
      if (durationStr) return durationStr
    }
    return '0天'
  }

  public setRoomToMoveOut(roomToMoveOut){
    this.roomToMoveOut = roomToMoveOut
    this.$axios.get('/rentermodel/renter/getScheduleMoveOutBOByRoomId',{params:{roomId:roomToMoveOut.id}}).then(resp => {
      if (resp.data.resultFlag === 40000) {
        this.roomToPost = resp.data.data
        this.roomToPost.moveOutDate = new Date()
      }
    })
    this.degreeModifyDiv.setRoomToModify(roomToMoveOut)
    this.modalShow=true
  }

  private moveOut(){
      this.roomToPost.roomDegreeDTO = this.degreeModifyDiv.getRoomDegrees()
      this.$axios.post("/rentermodel/renter/getScheduleMoveOutBOByRoomId")
  }

  @Emit("hasMoveOut") private hasMoveOut(){
  }
}
</script>

<style>

</style>