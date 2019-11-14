<template>
    <div>
  <span v-for="chargeTemplate in totalTemplate" :key='chargeTemplate.id'>
            <span v-if="chargeTemplateIdList.indexOf(chargeTemplate.id)>-1">
                <Tooltip placement="top">
                    <Tag :color='translateUnitCodeToString(chargeTemplate)[1]'>{{chargeTemplate.name}}</Tag>
                    <span slot="content" >{{chargeTemplate.amountPerUnit +' 元 / '+translateUnitCodeToString(chargeTemplate)[0]}}</span>
                </Tooltip>
            </span>
        </span>
    </div>
</template>

<script lang='ts'>
import {Component,Vue, Prop} from 'vue-property-decorator'
import {translateUnitCodeToString} from '@/assets/api'
@Component({components:{
}})
export default class App extends Vue {
    @Prop() private totalTemplate!:Array<any>;
    @Prop() private chargeTemplateIdList!:Array<any>;
    private translateUnitCodeToString =translateUnitCodeToString
}
</script>

<style>

</style>