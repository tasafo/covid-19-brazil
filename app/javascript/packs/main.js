function reportWindowSize() {
  var witdh = window.innerWidth
  var sidebar = document.getElementsByClassName('sidebar')[0]

  if ( witdh <= 600 ){
    sidebar.classList.add('mdc-layout-grid__cell--order-1')
  } else{
    sidebar.classList.remove('mdc-layout-grid__cell--order-1')
  }
}

// document.getElementById("container").addEventListener('resize', reportWindowSize)

(function(){
  reportWindowSize()
  window.addEventListener('resize', reportWindowSize)
})()