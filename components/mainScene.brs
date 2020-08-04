  function init()
    m.top.setFocus(true)
    m.myLabel = m.top.findNode("myLabel")
    m.myLabel.font.size=92
    m.myLabel.color="0x72D7EEFF"
    print "-------------------------"
    m.cacheTask = createObject("roSGNode","cacheTask")
    m.cacheTask.control = "RUN"
  end function