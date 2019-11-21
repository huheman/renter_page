<template>
<Modal v-model="modalShow"
      :title="modalTitle"
      :loading="modalLoading"
      width="650"
      @on-ok="modifyDegree">
    <DegreeModifyDiv ref="degreeModifyDiv" :totalTemplate='totalTemplate' @onFail='modalShow = false'/>
</Modal>
</template>

<script lang='ts'>
import {Component,Vue,Prop, Emit} from 'vue-property-decorator'
import DegreeModifyDiv from '@/components/degree-modify-div.vue'
@Component({components:{
  DegreeModifyDiv
}})
export default class App extends Vue {
    @Prop() private totalTemplate!:Array<any>
    private modalShow = false
    private modalLoading = true
    private modalTitle = '修改房间收费读数'

    get degreeModifyDiv(){
      let target:any = this.$refs.degreeModifyDiv
      return target
    }
    public setRoomToModify(roomToModify){
        this.modalShow = true
        this.degreeModifyDiv.setRoomToModify(roomToModify)
    }

    private modifyDegree() {
      let roomDegrees = this.degreeModifyDiv.getRoomDegrees()
      this.$axios.post("/chargemodel/chargeTemplate/postMoveInDegrees",roomDegrees).then(resp => {
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
      return this.degreeModifyDiv.getRoomDegrees()
    }
}
</script>

<style>

</style>