<template>
  <Modal v-model="modalShow"
      :title="modalTitle"
      :loading="modalLoading"
      width="550"
      @on-ok="moveIn">
      <Form :label-width="100">
        <Row :gutter='12'>
          <Col span="12">
            <FormItem label="房间名" >
              <Input readonly :value="roomToMoveIn.roomName"></Input>
            </FormItem>
          </Col>
          <Col span='12'>
            <FormItem label="押金" required >
              <InputNumber
            :max="10000"
            v-model="objToPost.deposit"
            :formatter="value => `￥ ${value}`"
            :step = '0.1'
            :parser="value => value.replace(/￥ /g, '')"
            style="width:100%"
            placeholder="请输入押金">
            </InputNumber>
            </FormItem>
          </col>
         </Row>
         

        <Row :gutter='12'>
          <Col span="19">
            <FormItem label="入住人" required >
              <Select v-model="objToPost.renterIdList" filterable clearable placeholder='必须把签合同人排在入住人第一' multiple>
                <Option v-for="item in moveInableRenterList" :value="item.id" :key="item.id">{{ item.name }}</Option>
              </Select>
            </FormItem>
          </Col>
          <Col span='5'>
            <Button type="info" long @click="newRenter">新增入住人</Button>
          </col>
         </Row>
         <Row :gutter='12'>
          <Col span="12">
            <FormItem label="入住日期" required >
              <DatePicker v-model="moveInDate" :clearable="false" ></DatePicker>
            </FormItem>
          </Col>
          <Col span='12'>
          <FormItem label="预计搬出日期" required >
              <DatePicker v-model="moveOutDate" :clearable="false"  ></DatePicker>
            </FormItem>
          </col>
          </Row>

          <Row >
          <Col span="18">
             <FormItem label="租约时长" required >
              <RadioGroup v-model="period"  style="width:100%" type="button">
                <Radio :label='0' >未知</Radio>
                <Radio :label='0.5' >半年</Radio>
                <Radio :label='1' >一年</Radio>
                <Radio :label='2' >两年</Radio>
                <Radio :label='3' >三年</Radio>
              </RadioGroup>
            </FormItem>
          </Col>
          <Col span='6'>
          <Button type="info" long @click="modifyDegrees">编辑各项初始读数</Button>
          </col>
          </Row>
          
         
      </Form>
  </Modal>
</template>

<script lang='ts'>
import {Component,Vue,Prop, Emit, Watch} from 'vue-property-decorator'
import moment from 'moment'
import axios from '@/plugins/axios';
@Component({components:{
}})
export default class App extends Vue {
  
  @Prop() private renterList!:Array<any>
  private roomToMoveIn:any={}
  private modalShow:boolean = false
  private modalTitle:string = '房间入住'
  private modalLoading:boolean = true
  private objToPost:any={renterIdList:[]}
  private moveInDate = new Date() // 搬入日期默认是当天
  private moveOutDate = null
  private period=0

  public setRoomToMoveIn(roomToMoveIn){
    this.roomToMoveIn = roomToMoveIn
    this.objToPost = {renterIdList:[],deposit:500,roomId: roomToMoveIn.id}
    this.period = 0
    this.modalShow=true
  }

  private moveIn(){
    this.objToPost.moveInDate = moment(this.moveInDate).format('YYYY-MM-DD')
    if (this.moveOutDate){
      this.objToPost.expectMoveOutDate = moment(this.moveOutDate).format('YYYY-MM-DD')
    }
    this.$axios.post("/roommodel/room/moveIn",this.objToPost).then(resp => {
      this.modalLoading=false
      this.$nextTick(() =>{
        this.modalLoading = true
      })
      if (resp.data.resultFlag===20000) {
        // 提示入住成功
        this.$Message.success(`住户${this.moveInableRenterList.filter(renter =>{
            return this.objToPost.renterIdList.indexOf(renter.id) >-1
        })[0].name}入住成功`)
        // 提醒父方法
        this.hasMoveIn()
        // 关闭提示窗
        this.modalShow = false
      }
    })
  }

  @Emit("hasMoveIn") private hasMoveIn(){
    return this.objToPost
  }

  @Emit("newRenter")private newRenter(){}

  @Emit("modifyDegrees")private modifyDegrees(){
    return this.roomToMoveIn
  }

  get moveInableRenterList(){
    return this.renterList.filter(renter =>{
      return renter.isPrimary !== 1
    })
  }

  get realChargeTemplateIdList(){
    return this.roomToMoveIn.chargeTemplateIdList?this.roomToMoveIn.chargeTemplateIdList:[]
  }

  @Watch("moveInDate")
  @Watch("period")
  private calculateMoveOutDate(){
    if (this.objToPost.period === 0) {
      this.moveOutDate = null
    }else{
      this.moveOutDate = moment(this.moveInDate).add(this.period,'years').calendar()
    }
  }
}
</script>

<style>

</style>