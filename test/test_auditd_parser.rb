require 'fluent/test'
require 'fluent/parser'
require 'json'
require_relative '../lib/fluent/plugin/viaq_docker_audit'


module ParserTest
  include Fluent
  
  class ViaqDockerAuditParserTest < ::Test::Unit::TestCase

    def setup()
      @parser = Fluent::ViaqDockerAudit.new()
    end
    
    data('line' => [
'{
  "time": "2017-09-25T06:45:23.246000+00:00",
  "systemd": {
    "t": {
      "PID": "1182",
      "UID": "0",
      "AUDIT_LOGINUID": "4294967295",
      "AUDIT_SESSION": "4294967295",
      "SELINUX_CONTEXT": "system_u:system_r:container_runtime_t:s0",
      "EXE": "\"/usr/bin/dockerd-current\""
    }
  },
  "docker": {
    "sauid": "1000",
    "container_id_short": "1235c5a6476b",
    "container_image": "centos:7",
    "pid": "10657",
    "user": "origin",
    "reason": "api",
    "operation": "resize",
    "result": "success",
    "command": "sleep"
  }
}', "type=VIRT_CONTROL msg=audit(1506321923.246:470): pid=1182 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:container_runtime_t:s0 msg='reason=api vm-pid=10657 hostname=1235c5a6476b op=resize vm=centos:7 user=origin auid=1000 exe=sleep  exe=\"/usr/bin/dockerd-current\" hostname=? addr=? terminal=? res=success'"])
    def test_correct_data(data)
      expected, target = data
      begin
        expected, target = data
        target_json = JSON.pretty_generate (@parser.parse_audit_line target)
        assert_equal(expected, target_json)
      rescue Fluent::ViaqDockerAudit::ViaqDockerAuditParserException => e
        fail(e.message)
      end
    end

    data('line' => ["expecting AuditdParserException", "type=VIRT_CONTROL msg=audit(1505977228.725:3309): pid=1115 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:container_runtime_t:s0 msg='auid=1000 exe=? reason=api op=_ping vm=? vm-pid=? user=jkarasek hostname=?  exe=\"/usr/bin/dockerd-current\" hostname=? addr=? terminal=? res=success"])
    def test_missing_apostrophe(data)
      expected, target = data
      assert_raise Fluent::ViaqDockerAudit::ViaqDockerAuditParserException do 
        JSON.pretty_generate (@parser.parse_audit_line target)
      end
    end

    private

    def fail(reason)
      assert(false, reason)
    end

  end
end
