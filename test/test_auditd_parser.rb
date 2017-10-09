require 'fluent/test'
require 'fluent/parser'
require 'json'
require_relative '../lib/fluent/plugin/auditd'


module ParserTest
  include Fluent
  
  class AuditdParserTest < ::Test::Unit::TestCase

    def setup()
      @parser = Fluent::Auditd.new()
    end
    
    data('line' => [
'{
  "type": "VIRT_CONTROL",
  "time": "1505977228.725",
  "pid": "1115",
  "uid": "0",
  "auid": "4294967295",
  "ses": "4294967295",
  "subj": "system_u:system_r:container_runtime_t:s0",
  "msg": {
    "auid": "1000",
    "reason": "api",
    "op": "_ping",
    "user": "jkarasek",
    "exe": "\"/usr/bin/dockerd-current\"",
    "res": "success"
  }
}', "type=VIRT_CONTROL msg=audit(1506321923.246:470): pid=1182 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:container_runtime_t:s0 msg='reason=api vm-pid=10657 hostname=1235c5a6476b op=resize vm=centos:7 user=origin auid=1000 exe=sleep  exe=\"/usr/bin/dockerd-current\" hostname=? addr=? terminal=? res=success'"])
    def test_correct_data(data)
      expected, target = data
      puts JSON.pretty_generate (@parser.parse_auditd_line target)
      # begin
      #   expected, target = data
      #   target_json = JSON.pretty_generate (@parser.parse_auditd_line target)
      #   assert_equal(expected, target_json)
      # rescue Fluent::Auditd::AuditdParserException => e
      #   fail(e.message)
      # end
    end

    data('line' => ["expecting AuditdParserException", "type=VIRT_CONTROL msg=audit(1505977228.725:3309): pid=1115 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:container_runtime_t:s0 msg='auid=1000 exe=? reason=api op=_ping vm=? vm-pid=? user=jkarasek hostname=?  exe=\"/usr/bin/dockerd-current\" hostname=? addr=? terminal=? res=success"])
    def test_missing_apostrophe(data)
      expected, target = data
      assert_raise Fluent::Auditd::AuditdParserException do 
        JSON.pretty_generate (@parser.parse_auditd_line target)
      end
    end

    private

    def fail(reason)
      assert(false, reason)
    end

  end
end