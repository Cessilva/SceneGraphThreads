sub Main()
    print "in showChannelSGScreen"
    screen = CreateObject("roSGScreen")
    m.port = CreateObject("roMessagePort")
    screen.setMessagePort(m.port)

    scene = screen.CreateScene("mainScene")
    screen.show()

    WriteAsciiFile("tmp:/config.txt", "Hola me llamo ceci")

    text=ReadAsciiFile("tmp:/config.txt")
    print "------READ/WRITE TMP MEMORY------------"
    print text

    ' Other place where we could need to storage data, is when we use screensavers
    ' https://developer.roku.com/es-mx/docs/developer-program/media-playback/screensavers.md

    WriteAsciiFile("cachefs:/config.txt", "Hola me llamo ceci desde el cache")
    text=ReadAsciiFile("cachefs:/config.txt")
    print "------READ/WRITE CACHEFS MEMORY------------"
    print text


    while(true)
        msg = wait(0, m.port)
        msgType = type(msg)
        if msgType = "roSGScreenEvent"
            if msg.isScreenClosed() then return
        end if
    end while
end sub

