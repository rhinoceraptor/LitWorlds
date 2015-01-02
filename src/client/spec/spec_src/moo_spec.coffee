describe "moo", ->
  it "should load instance of text_handler class into the 'app' namespace", ->
    expect(app.text).toBeDefined()
  
  it "should define moo_name from params", ->
    expect(moo_name).toEqual("Literary Worlds")

  it "should define host_name from params", ->
    expect(host_name).toEqual("brn227.brown.wmich.edu")

  it "should define sock_server from params", ->
    expect(sock_server).toEqual("127.0.0.1")

  it "should define port from params", ->
    expect(port).toEqual("7777")

  it "should define font from params", ->
    expect(font).toEqual("Courier New")

  it "should define fontsize from params", ->
    expect(fontsize).toEqual("12")

  it "should define localecho from params", ->
    expect(localecho).toEqual("false")

