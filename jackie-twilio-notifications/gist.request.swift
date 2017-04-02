import Alamofire

Alamofire.request(.POST, "http://localhost:3000/request", headers: ["Content-Type":"application/x-www-form-urlencoded"  ],
            parameters:["telephone1" : name1, "telephone2" : name2]).response(completionHandler: {
                (request, response, data, error) in
                print(request)
                print(response)
                print(data)
                print(error)
            })
