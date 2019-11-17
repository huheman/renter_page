import moment from 'moment'
/**前往所有组别的页面 */
export function toGroup(){
   this.$router.push({path:"/room-group"})
}

/** 前往组别对应的房间列表页面 */
export function toRoomPage(groupId){
    let path = "/room"
    let query;
    if(groupId){
        query = {currentPane : 'group'+groupId}
    }
    this.$router.push({path:path,query:query})
}

export function translateUnitCodeToString(chargeTemplate){
    let color = 'default'
    let unit=''
    switch (chargeTemplate.unit) {
        case 0:
            unit = '度'
            break
        case 1:
            unit = '天'
            break
            return ['天','warning']
        case 2:
            unit = '月'
            break
        case 3:
            unit = '年'
            break
    }
    if(chargeTemplate.isDisabled != 1){
        switch (chargeTemplate.unit) {
            case 0:
                color= 'blue'
                break
            case 1:
                color = 'warining'
                break
            case 2:
                color = 'purple'
                break
            case 3:
                color = 'magenta'
                break
        }
    }
    return [unit,color]
    
}

export function formattedMoney(val){
    console.log(val)
    if (val){
        return val.replace(/\B(?=(\d{3})+(?!\d))/g, ',')
    }
}

export function formateDate(date){
    return moment(date).format("YYYY-MM-DD")
  }