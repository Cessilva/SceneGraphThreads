function init()
m.files = createObject("roFileSystem")
m.files.Copyfile( "pkg:/images/roku.png" , "cachefs:/roku.png" ) 
print m.files.exists("cachefs:/roku.png")
end function