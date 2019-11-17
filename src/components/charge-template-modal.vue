<template>
  <div>
      <Modal
      v-model="modalShow"
      :title="modalTitle"
      :loading="modalLoading"
      width="535"
      @on-ok="postChargeTemplate"
    >
      <Form ref='roomForm' :model="objInModal" :label-width="100">
        <Row >
          <Col span = '20'>
          <FormItem label="费用模板名称" required >
            <Input v-model="objInModal.name" placeholder="请输入费用模板姓名"></Input>
          </FormItem>
          </Col>
          <Col span='4'>
          <FormItem :label-width="20">
            <Checkbox v-model="objInModal.isDisabled" :true-value='0' :false-value='1'>激活</Checkbox>
          </FormItem>
          </Col>
        </Row>
         
        <FormItem label="费用模板描述">
          <Input
            type="textarea"
            :autosize="{minRows: 2,maxRows: 5}"
            v-model="objInModal.desc"
            placeholder="请输入费用模板的介绍"></Input>
        </FormItem>
        
        <FormItem label="收费标准" required  >
          <Row >
            <Col span = '16'>
            <InputNumber
            :max="10000"
            v-model="objInModal.amountPerUnit"
            :formatter="value => `￥ ${value}`.replace(/\B(?=(\d{3})+(?!\d))/g, ',')"
            :step = '0.1'
            :parser="value => value.replace(/￥\s?|(,*)/g, '')"
            style="width:100%"
            placeholder="请输入每单位费用">
            </InputNumber>
            </Col>
            <Col span = '7' offset='1'>
              <div style="text-align:'right'">
                <Select  v-model="objInModal.unit"  style="width: 100%">
                <Option :value="0">度</Option>
               <Option :value="1">天</Option>
                <Option :value="2">月</Option>
                <Option :value="3">年</Option>
              </Select>
              </div>
            </Col>
          </Row>
        </FormItem>

      </Form>
    </Modal>
  </div>
</template>

<script lang=ts>
import {Component,Vue, Prop,Watch} from 'vue-property-decorator'
import axios from '@/plugins/axios';
import moment from 'moment';
@Component({components:{
}})
export default class App extends Vue {
    private modalShow = false
    private modalTitle= ''
    private modalLoading=true;
    private objInModal:any ={}

    private postChargeTemplate(){
      this.$axios.post("/chargemodel/chargeTemplate",this.objInModal).then(resp => {
        this.modalLoading = false;
        this.$nextTick(()=>{
          this.modalLoading = true;
        })
        if (resp.data.resultFlag == 20000) {
          this.$Message.success("保存模板成功")
          this.modalShow = false
          this.$emit('onPostSuccess',this.objInModal)
        }
      })
    }


    private init(){
      this.objInModal = {isDisabled : 0,unit:0}
      this.modalTitle = '创建费用模板'
      this.modalShow = true
    }

    private setobjInModal(objInModal){
      this.objInModal = JSON.parse(JSON.stringify(objInModal))
      this.modalTitle = '修改费用模板'
      this.modalShow = true
    }

    mounted(){}
}
</script>

<style>

</style>