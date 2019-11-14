import Vue from 'vue'
import Router from 'vue-router'
import Home from './views/Home.vue'
import RoomGroup from '@/components/room-group-manager.vue'
import Room from '@/components/room-manager.vue'
import Renter from '@/components/renter-manager.vue'
import ChargeTemplate from '@/components/charge-template-manager.vue'

Vue.use(Router)

export default new Router({
  mode: 'history',
  base: process.env.BASE_URL,
  routes: [
    {
      path: '/',
      name: 'home',
      component: Home
    },
    {
      path: '/about',
      name: 'about',
      // route level code-splitting
      // this generates a separate chunk (about.[hash].js) for this route
      // which is lazy-loaded when the route is visited.
      component: () => import(/* webpackChunkName: "about" */ './views/About.vue')
    },
    {
      path: '/room-group',
      name: 'roomGroup',
      component: RoomGroup
    },
    {
      path: '/room',
      name: 'room',
      component: Room
    },
    {
      path: '/renter',
      name: 'renter',
      component: Renter
    },
    {
      path: '/chargeTemplate',
      name: 'chargeTemplate',
      component: ChargeTemplate
    },
    {
      path: '/test',
      name: 'test',
      component: () => import('@/components/test.vue')
    }
    
  ]
})
