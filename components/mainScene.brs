  function init()
    m.top.setFocus(true)
    m.myLabel = m.top.findNode("myLabel")
    m.myLabel.font.size=92
    m.myLabel.color="0x72D7EEFF"
    print "-----------CACHE--------------"
    m.cacheTask = createObject("roSGNode","cacheTask")
    m.cacheTask.control = "RUN"

    print "------------REGISTRY-------------"
    m.registryTask = createObject("roSGNode","registryTask")
    m.registryTask.control = "RUN"
    m.registryTask.observeField("text","onChangeText")
    m.data=GetAuthData()
    print m.data
  end function

  Function GetAuthData() As Dynamic
  sec = CreateObject("roRegistrySection", "Authentication")
  if sec.Exists("UserRegistrationToken")
      return sec.Read("UserRegistrationToken")
  endif
  return invalid
End Function