application = 
    {
        content =
        {
            width = 320,
            height = 480,
            scale = "letterBox",
            -- scale = "zoomEven",
            -- scale = "zoomStretch",
            xAlign = "center",
            yAlign = "center",
            imageSuffix = 
            {
                ["@2x"] = 1.5,
                ["@4x"] = 3
            },
        },
        notification = 
        {
            iphone = {
                types = {
                    "badge", "sound", "alert"
                }
            }
        }
    }
