# Description:
#   Manage your DNSimple account simply
#
# Commands:
#   hubot dns:list DOMAIN/RECORDS_TYPE - List records for a domain
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
