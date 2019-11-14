<template>
  <div>
      <Modal
      v-model="modalShow"
      :title="modalTitle"
      :loading="modalLoading"
      width="535"
      @on-ok="postRenter">
      <Form ref='roomForm' :model="renterInModal" :label-width="80">
          <Row :gutter='8'>
              <Col span="12">
              <FormItem label="租户姓名" required >
                <Input v-model="renterInModal.name" placeholder="请输入租户姓名"></Input>
                </FormItem>
              </Col>
              <Col span='12' >
                <FormItem label="性别" required >
                  <RadioGroup v-model="renterInModal.gender" >
                    <Radio :label="0">
                        <Icon type="ios-woman" />
                        <span>女</span>
                    </Radio>
                    <Radio :label="1">
                       <Icon type="ios-man" />
                        <span>男</span>
                    </Radio>
                  </RadioGroup>
                </FormItem>
              </Col>
          </Row>
        <Row :gutter='8'>
              <Col span="12">
        <FormItem label="手机号码" required>
          <Input
            v-model="renterInModal.mobile"
            placeholder="请输入手机号码"></Input>
        </FormItem>
        </Col>
        <Col span='12' >
                <FormItem label="出生日期" required  >
                  <DatePicker v-model="birthday" type="date" :options='dateOption' placeholder="请选择出生日期" ></DatePicker>
                </FormItem>
        </Col>
        </Row>
        <Row :gutter='8'>
        <Col span='12' >
                <FormItem label="微信号" required  >
                   <Input 
            v-model="renterInModal.wechatNum"
            placeholder="请输入微信号"></Input>
                </FormItem>
        </Col>
        <Col span='12' >
                <FormItem label="身份号码" required  >
                   <Input v-model="renterInModal.creditNum"
            placeholder="请输入身份证号"></Input>
                </FormItem>
        </Col>
        </Row>
        <FormItem label="所在房间"  >
          <Input readonly :value="getRoomName(renterInModal.roomId)" placeholder='应考虑通过出租操作进行住户与房间的绑定' >
          </Input>
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
    private allRooms=[]
    private renterInModal:any ={}
    private birthday:Date = new Date()
    private dateOption= {
      disabledDate(date){
        return date && date.valueOf() > Date.now() 
      }
    }

    @Watch('birthday')
    private onBirthdayChanged(to,from){
      this.renterInModal.birthday = moment(to).format('YYYY-MM-DD')
    }

    private postRenter(){
      axios.post("/rentermodel/renter",this.renterInModal).then(resp => {
        this.modalLoading = false;
        this.$nextTick(()=>{
          this.modalLoading = true;
        })
        if (resp.data.resultFlag == 20000) {
          this.$Message.success("保存租户成功")
          this.modalShow = false
          this.$emit('onPostSuccess',this.renterInModal)
        }
      })
    }


    private init(){
      this.renterInModal = {gender :0}
      this.modalTitle = '创建租户'
      this.modalShow = true
      this.birthday = new Date()
    }

    private setRenterInModal(renterInModal){
      this.renterInModal = JSON.parse(JSON.stringify(renterInModal))
      this.modalTitle = '修改租户'
      this.modalShow = true
      if (renterInModal.birthday) {
        this.birthday = new Date(renterInModal.birthday)
      }
    }

    mounted(){
      axios.get("/roommodel/room/listAll").then(resp => {
          this.allRooms = resp.data.data
      })
    }

    private getRoomName(roomId){
      for(let room of this.allRooms){
        if (room.id === roomId) {
          return room.roomName
        }
      }
      return roomId
    }
    
}
</script>

<style>

</style>