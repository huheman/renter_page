<template>
  <div id="app">
    <router-view/>
  </div>
</template>

<script>
import {Component,Vue} from 'vue-property-decorator'
import '@/assets/base.css';
@Component({components:{
}})
export default class App extends Vue {}
</script>

<style>
#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 20px;
}
</style>
