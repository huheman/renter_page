<template>
<Modal v-model="modalShow"
      :title="modalTitle"
      :loading="modalLoading"
      width="650"
      @on-ok="modifyDegree">
    <Form :label-width="100">
    <Row>
        <FormItem label="收费项目" >
            <ChargeTemplateTab :chargeTemplateIdList='roomToModify.chargeTemplateIdList' :totalTemplate='totalTemplate'></ChargeTemplateTab>
        </FormItem>
    </Row>
    <div style="position: relative">
      <Spin fix v-if="spinLoading"></Spin>
      <Row v-for="degreeToModify in roomDegrees.degreeList" :key="degreeToModify.chargeTemplateId" :gutter='12'>
        <Col span='10'>
          <FormItem  :label="`${findTemplateName(degreeToModify.chargeTemplateId)}读数`" required >
            <Tooltip :content=' (degreeToModify.coverDegreeStart ?  "最近一次读数数值为：" + degreeToModify.coverDegreeStart :"暂未有最近读数记录")' placement="top">
              <InputNumber
                v-model="degreeToModify.coverDegreeEnd"
                :step = '1'
                style="width:100%"
                :disabled='!degreeToModify.active'
                :placeholder="`请输入入住时${findTemplateName(degreeToModify.chargeTemplateId)}的读数`">
              </InputNumber>
            </Tooltip>
          </FormItem>
        </Col>
        <Col span="10">
          <FormItem label="读数生效时间" required >
            <Tooltip :content='(degreeToModify.coverWhenStart ? "最近一次读数时间为：" + formateDate(degreeToModify.coverWhenStart) : "暂未有最近读数记录")' placement="top">
              <DatePicker v-model="degreeToModify.coverWhenEnd" :clearable="false" style="width:100%" :disabled='!degreeToModify.active' ></DatePicker>
            </Tooltip>
          </FormItem>
        </Col>
        <Col span="4">
          <FormItem :label-width="0">
            <Checkbox v-model="degreeToModify.active">修改开关</Checkbox>
          </FormItem>
        </Col>
      </Row>
    </div>
    </Form>
</Modal>
</template>

<script lang='ts'>
import {Component,Vue,Prop, Emit} from 'vue-property-decorator'
import ChargeTemplateTab from '@/components/charge-template-tab.vue'
import {formateDate} from '@/assets/api'
import moment from 'moment'
@Component({components:{
    ChargeTemplateTab
}})
export default class App extends Vue {
    @Prop() private totalTemplate!:Array<any>
    private roomToModify:any={chargeTemplateIdList:[]}
    private roomDegrees:any = {degreeList:[]}
    private modalShow = false
    private modalLoading = true
    private spinLoading = true
    private modalTitle = '修改房间收费读数'

    public setRoomToModify(roomToModify){
        this.roomToModify = roomToModify
        this.spinLoading = true
        this.modalShow = true
        // 获取此房间现在的度数
        this.$axios.get("/chargemodel/chargeTemplate/queryRoomDegrees",{params:{roomId: roomToModify.id}})
        .then(resp => {
          this.roomDegrees = resp.data.data
          this.roomDegrees.degreeList.forEach(element => {
            // 如果时间end为空，则把时间end设为今日
            if(!element.coverWhenEnd){
              element.coverWhenEnd = moment().calendar()
            } else {
              // 如果时间end有值，则把时间start设为时间end
              element.coverWhenStart = element.coverWhenEnd
            }
            // 如果coverDegreeEnd为空，则把他设为0
            if(!element.coverDegreeEnd){
              element.coverDegreeEnd = 0
            } else {
              // 否则把coverStart设为coverEnd
              element.coverDegreeStart = element.coverDegreeEnd
            }
          })
          this.spinLoading = false
        })
    }

    private modifyDegree() {
      this.$axios.post("/chargemodel/chargeTemplate/modifyDegrees",this.roomDegrees).then(resp => {
        this.modalLoading = false
        this.$nextTick(() => {
          this.modalLoading = true
        })
        if (resp.data.resultFlag === 20000 ){
          this.modalShow = false
          this.hasModify()
          if (resp.data.msg){
            this.$Message.success(resp.data.msg)
          }
          
        }
      })
    }

    @Emit("hasModify") private hasModify(){
      return this.roomDegrees
    } 

    private findTemplateName(templateId){
      for (let template of this.totalTemplate){
        if(template.id == templateId){
          return template.name
        }
      }
    }

    private formateDate = formateDate
    
    
}
</script>

<style>

</style>