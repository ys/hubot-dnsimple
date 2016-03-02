# Description:
#   Manage your DNSimple account simply
#
# Commands:
#   hubot dns:list DOMAIN/RECORDS_TYPE - List records for a domain
#   hubot dns:create NAME/DOMAIN for CONTENT - Create a record
#   hubot dns:create:TYPE NAME/DOMAIN for CONTENT - Create a record of type TYPE
#   hubot dns:create:TYPE NAME/DOMAIN for CONTENT with ttl TIME- Create a record of type TYPE with a custom ttl
#

client = require("dnsimple")({
  email: process.env.HUBOT_DNSIMPLE_EMAIL,
  token: process.env.HUBOT_DNSIMPLE_TOKEN
})

module.exports = (robot) ->
  robot.respond /dns:list ([^\/]*)(?:\/?(\w*))$/i, (msg) ->
    domain = msg.match[1]
    recordsType = msg.match[2] || "CNAME"
    client "GET", "/domains/#{domain}/records", { type: recordsType }, (err, data) ->
      if err
        msg.send "oops #{err}"
        return

      robot.emit "dnsimple_records_list", msg, domain, data

  robot.respond /dns:create(?:\:(\w)+)? (\w+)\/([^\s]+) with ([\s]+)(?:\swith ttl (\d+))?$/, (msg) ->
    type = msg.match[1] || "CNAME"
    name = msg.match[2]
    domain = msg.match[3]
    content = msg.match[4]
    ttl = msg.match[5] || 3600
    record =
      record_type: type,
      name: name,
      content: content,
      ttl: ttl
    client "POST", "/domains/#{domain}/records", record, (err, data) ->
      if err
        msg.send "oops #{err}"
        return

      robot.emit "dnsimple_records_create", msg, domain, data
