<template>
 <div>
    <Form :label-width="100">
    <Row>
        <FormItem label="收费项目" >
            <ChargeTemplateTab :chargeTemplateIdList='roomToModify.chargeTemplateIdList' :totalTemplate='totalTemplate'></ChargeTemplateTab>
        </FormItem>
    </Row>
    <div style="position: relative">
      <Spin fix v-if="spinLoading"></Spin>
      <Row v-for="degreeToModify in roomDegrees.degreeList" :key="degreeToModify.chargeTemplateId" :gutter='12'>
        <Col :span='isMoveOut ? "24" : "10"'>
          <FormItem  required >
            <span slot="label"><span style='color:blue'>{{findTemplateName(degreeToModify.chargeTemplateId)}}</span>读数</span>
            <Tooltip :content=' (degreeToModify.coverDegreeStart ?  "最近一次读数数值为：" + degreeToModify.coverDegreeStart :"暂未有最近读数记录")' style="width:100%" placement="top">
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
        <Col span="10" v-if='!isMoveOut'>
          <FormItem label="读数生效时间" required >
            <Tooltip :content='(degreeToModify.coverWhenStart ? "最近一次读数时间为：" + formateDate(degreeToModify.coverWhenStart) : "暂未有最近读数记录")' placement="top">
              <DatePicker v-model="degreeToModify.coverWhenEnd" :clearable="false" style="width:100%" :disabled='!degreeToModify.active' ></DatePicker>
            </Tooltip>
          </FormItem>
        </Col>
        <Col span="4" v-if='!isMoveOut'>
          <FormItem :label-width="0">
            <Checkbox v-model="degreeToModify.active">修改开关</Checkbox>
          </FormItem>
        </Col>
      </Row>
    </div>
    </Form>
 </div>
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
    // 设置degreeModifyDiv为moveOut模式
    // 当处于moveOut模式，会隐藏生效时间Input
    // 以moveOutDate作为所有读数的cover_when_end
    // 并且所有读数默认激活
    @Prop() private moveOutDate!:Date
    @Prop() private isMoveOut!:boolean
    private roomToModify:any={chargeTemplateIdList:[]}
    private roomDegrees:any = {degreeList:[]}
    private spinLoading = true

    public setRoomToModify(roomToModify){
        this.roomToModify = roomToModify
        this.spinLoading = true
        // 获取此房间现在的度数，如果是用于设置入住时初始值，则要求bill的type为基础bill或搬出bill
        let url = '/chargemodel/chargeTemplate/queryMoveInRoomDegrees'
        if (this.isMoveOut) {
          // 如果是用于设置搬出的值，则要求bill为已审核，已生成，type为基础bill
          url = '/chargemodel/chargeTemplate/queryMoveOutRoomDegrees'
        }
        this.$axios.get(url,{params:{roomId: roomToModify.id}})
        .then(resp => {
          // 如果有什么数据
          if (resp.data.resultFlag != 40000){
            this.$emit('onFail')
            return
          }
          this.roomDegrees = resp.data.data
          this.roomDegrees.degreeList.forEach(element => {
            // 如果时间end为空，说明没有过bill，可以则把时间end设为今日
            if(!element.coverWhenEnd){
              element.active = true
              element.coverWhenEnd = moment().format('YYYY-MM-DD')
            } else {
              // 如果时间end有值，则把时间start设为时间end
              element.active = false
              element.coverWhenStart = element.coverWhenEnd
            }
            // 如果coverDegreeEnd为空，说明没有过bill，则把coverDegreeEnd设为0
            if(!element.coverDegreeEnd){
              element.active= true
              element.coverDegreeEnd = 0
            } else {
              // 否则把coverStart设为coverEnd
              element.active = false
              element.coverDegreeStart = element.coverDegreeEnd
            }
            // 如果处于moveOut模式，则把active设为ture
            if (this.isMoveOut){
              element.active = true
            }
          })
          this.spinLoading = false
        })
    }

    public getRoomDegrees(){
      return this.roomDegrees;
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