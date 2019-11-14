<template>
<div class='baseDiv'>
    <div class='buttonDiv'>
        <ButtonGroup class='buttionGroup'>
            <Button icon='md-add' type="primary" @click="initModal"  shape='circle'>创建费用模板</Button>
            <Button icon='ios-apps' @click='toRoomPage()' shape='circle'>所有房间</Button>
        </ButtonGroup>
    </div>
    <div class='baseTable'>
        <ChargeTemplateTable ref="chargeTemplateTable" @modifyChargeTemplate = 'modifyChargeTemplate'  class='table'>
            
        </ChargeTemplateTable>
    </div>
    <ChargeTemplateModal ref='chargeTemplateModal' @onPostSuccess='onPostSuccess'>
    </ChargeTemplateModal>
</div>
</template>

<script lang='ts'>
import {Component,Vue} from 'vue-property-decorator'
import {toRoomPage} from '@/assets/api'
import ChargeTemplateTable from '@/components/charge-template-table.vue'
import ChargeTemplateModal from '@/components/charge-template-modal.vue'
@Component({components:{
    ChargeTemplateTable,
    ChargeTemplateModal
}})
export default class App extends Vue {

    get chargeTemplateModal():any{
        return this.$refs.chargeTemplateModal
    }

    get chargeTemplateTable():any{
        return this.$refs.chargeTemplateTable
    }
    

    private toRoomPage = toRoomPage

    private initModal(){
        this.chargeTemplateModal.init()
    }

    private onPostSuccess(){
        this.chargeTemplateTable.getchargeTemplateByPage()
    }

    private modifyChargeTemplate(chargeTemplate){
        this.chargeTemplateModal.setobjInModal(chargeTemplate)
    }
    
}
</script>

<style>

</style>