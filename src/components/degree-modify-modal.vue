<template>
<Modal v-model="modalShow"
      :title="modalTitle"
      :loading="modalLoading"
      width="550"
      @on-ok="modifyDegree">
    <Form :label-width="80">
    <Row>
        <FormItem label="收费项目" >
            <ChargeTemplateTab :chargeTemplateIdList='realChargeTemplateIdList' :totalTemplate='totalTemplate'></ChargeTemplateTab>
        </FormItem>
         </Row>
         <Row v-for="(template , templateIndex) in totalTemplate" :key="template.id">
             <div v-if="realChargeTemplateIdList.indexOf(template.id) >-1 && template.unit == 0">
             <Col span='12'>
           <FormItem  :label="`${template.name}读数`" >
             <InputNumber
            v-model="objToPost.degrees[templateIndex].value"
            :step = '1'
            style="width:100%"
            :placeholder="`请输入入住时${template.name}的读数`">
            </InputNumber>
           </FormItem>
           </Col>
           <Col span="12">
           <FormItem label="读数生效时间" required >
              <DatePicker v-model="objToPost.degrees[templateIndex].activeDate" :clearable="false"  ></DatePicker>
            </FormItem>
           </Col>
           </div>
         </Row>
         {{objToPost}}
    </Form>
</Modal>
</template>

<script lang='ts'>
import {Component,Vue,Prop} from 'vue-property-decorator'
import ChargeTemplateTab from '@/components/charge-template-tab.vue'
@Component({components:{
    ChargeTemplateTab
}})
export default class App extends Vue {
    @Prop() private totalTemplate!:Array<any>
    private roomToModify:any={}
    private objToPost:any = {}
    private modalShow = false
    private modalLoading = true
    private modalTitle = '修改房间收费读数'

    public setRoomToModify(roomToModify){
        this.roomToModify = roomToModify
        this.objToPost = {roomId:this.roomToModify.id,degrees:[]}
        this.modalShow = true
    }

    get realChargeTemplateIdList(){
    return this.roomToModify.chargeTemplateIdList?this.roomToModify.chargeTemplateIdList:[]
  }
    private modifyDegree(){

    }

}
</script>

<style>

</style>