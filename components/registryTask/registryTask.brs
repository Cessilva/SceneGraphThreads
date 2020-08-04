function init()
    SetAuthData("name")
   
end function

Function SetAuthData(userToken As String) As Void
    sec = CreateObject("roRegistrySection", "Authentication")
    sec.Write("UserRegistrationToken", userToken)
    sec.Flush()
End Function