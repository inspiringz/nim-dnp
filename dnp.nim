import os
import times
import streams
import strutils
#import parsecfg
import argparse
import sequtils
import itertools

#[
let
  Section = ["environment", "role", "technology", "service", "monitor",
    "proxy", "version", "time", "space", "area", "application", "number"]

type
  Config = array[Section.len, seq[string]]
]#

var config_simple: seq[seq[string]] = @[@["dev", "pre", "test", "t1", "staging", "st", "st1", "pro", "prod", "uat"], @["qa", "fe", "backend", "be"], @["api", "apis"], @["rest", "html5", "h5", "web", "app", "apps", "wx", "weixin", "m"], @["monitor", "dashboard"], @["proxy", "corp", "internal", "lb", "nginx", "gateway"], @["demo", "alpha", "beta", "stable", "release", "ga", "rc"], @["preview", "previous", "new", "new1", "old"], @["east", "south", "west", "north", "southeast", "northwest", "es", "nt", "tx", "tencent", "ali", "aliyun", "aws", "center"], @["huadong", "hd", "huaxi", "hx", "huanan", "hn", "huabei", "hb", "japan", "jp", "hongkong", "hk", "shanghai", "sh", "beijing", "bj", "us"], @["dc", "es", "h5", "mq", "oa", "uc", "zk", "api", "apm", "bbs", "biw", "bot", "bus", "cat", "cms", "crm", "dc1", "doc", "ec2", "efk", "elk", "gce", "git", "hub", "job", "jpa", "jwt", "k8s", "lib", "log", "mbs", "mgt", "mvc", "nms", "pan", "pay", "pod", "rpc", "scm", "srv", "sso", "svn", "tms", "wms", "www", "amqp", "apis", "app1", "apps", "auth", "avro", "blog", "boot", "data", "docs", "file", "flex", "gogs", "good", "grid", "guns", "hdfs", "hive", "kube", "ldap", "live", "logs", "mail", "mqtt", "nifi", "node", "note", "open", "pipe", "pods", "repo", "shop", "show", "solr", "team", "tsdb", "user", "wiki", "work", "zuul", "admin", "apiv1", "apiv2", "apiv3", "apiv4", "apiv5", "app01", "azure", "batch", "beats", "cacti", "camel", "chaos", "dubbo", "event", "feign", "flink", "flume", "geode", "gitea", "goods", "graph", "group", "habor", "hbase", "html5", "infra", "kafka", "label", "maven", "mesos", "micro", "minio", "nacos", "neo4j", "nerve", "nexus", "node1", "oauth", "oozie", "redis", "route", "scala", "spark", "sqoop", "stack", "store", "storm", "webui", "api-v1", "api-v2", "api-v3", "api-v4", "api-v5", "center", "client", "consul", "devops", "docker", "eureka", "falcon", "galaxy", "github", "gitlab", "goblin", "gradle", "group1", "hadoop", "harbor", "influx", "kibana", "lcinga", "logapi", "logger", "manage", "mobile", "nagios", "node01", "oauth2", "office", "pgraph", "portal", "ribbon", "router", "scribe", "search", "server", "sleuth", "spark1", "splunk", "spring", "stream", "syslog", "sysmon", "tracer", "triton", "tuning", "web-ui", "weblog", "zabbix", "zipkin", "airflow", "akumuli", "ansible", "bigdata", "breaker", "brogmon", "catalog", "circuit", "content", "control", "datadog", "diagram", "elastic", "eureka1", "fluentd", "gateway", "gemfire", "grafana", "hystrix", "invoker", "jenkins", "jupyter", "kinesis", "library", "logging", "manager", "meeting", "metrics", "monitor", "netdata", "netflix", "nodered", "payment", "pushapi", "recruit", "restapi", "restful", "rsyslog", "service", "storage", "tracing", "turbine", "webflow", "activemq", "actuator", "cadvisor", "collectd", "contract", "dataflow", "elkstack", "exporter", "filebeat", "graphite", "heapster", "influxdb", "librenms", "logstash", "marathon", "node-red", "opentsdb", "pipeline", "platform", "push-api", "rabbitmq", "schedule", "searcher", "tracking", "training", "analytics", "atlassian", "cassandra", "community", "dashboard", "developer", "discovery", "dockerhub", "dzzoffice", "elk-stack", "kubernete", "logsearch", "mapreduce", "office365", "openstack", "pagerduty", "serverset", "terraform", "websocket", "zookeeper", "clickhouse", "cloudwatch", "confluence", "dashboards", "datacenter", "dispatcher", "kube-state", "kubernetes", "management", "openfalcon", "prometheus", "servicelog", "skywalking", "usercenter", "data-center", "eureka-zuul", "kube-status", "loganalysis", "open-falcon", "opentracing", "pushgateway", "recruitment", "restful-api", "service-log", "serviceslog", "user-center", "alertmanager", "eureka-admin", "grafana-kong", "push-gateway", "services-log", "elasticsearch", "eureka-client", "eureka-server", "node-exporter", "kong-dashboard", "grafana-dashboard", "grafana-management"], @["1", "2", "3", "01", "02", "03", "v1", "v2", "v3"]]

var config_default: seq[seq[string]] = @[@["dev", "pre", "prepare", "test", "test1", "t1", "staging", "st", "st1", "prd", "pro", "prod", "p1", "pr", "uat", "sit"], @["qa", "qa1", "qa3", "front", "frontend", "fe", "backend", "be"], @["api", "apis"], @["rest", "restful", "html5", "h5", "web", "app", "apps", "wx", "weixin", "mobile", "m", "wap"], @["admin", "monitor", "manager", "dashboard", "management"], @["proxy", "corp", "internal", "cluster", "cluster1", "lb", "nginx", "ng", "gateway", "gw"], @["demo", "alpha", "beta", "stable", "release", "ga", "rc"], @["preview", "previous", "new", "new1", "old"], @["east", "south", "west", "north", "southeast", "northwest", "es", "nt", "tx", "tencent", "ali", "aliyun", "aws", "center"], @["huadong", "hd", "huaxi", "hx", "huanan", "hn", "huabei", "hb", "japan", "jp", "hongkong", "hk", "shanghai", "sh", "beijing", "bj", "us"], @["dc", "es", "h5", "mq", "oa", "uc", "zk", "api", "apm", "bbs", "biw", "bot", "bus", "cat", "cms", "crm", "dc1", "doc", "ec2", "efk", "elk", "gce", "git", "hub", "job", "jpa", "jwt", "k8s", "lib", "log", "mbs", "mgt", "mvc", "nms", "pan", "pay", "pod", "rpc", "scm", "srv", "sso", "svn", "tms", "wms", "www", "amqp", "apis", "app1", "apps", "auth", "avro", "blog", "boot", "data", "docs", "file", "flex", "gogs", "good", "grid", "guns", "hdfs", "hive", "kube", "ldap", "live", "logs", "mail", "mqtt", "nifi", "node", "note", "open", "pipe", "pods", "repo", "shop", "show", "solr", "team", "tsdb", "user", "wiki", "work", "zuul", "admin", "apiv1", "apiv2", "apiv3", "apiv4", "apiv5", "app01", "azure", "batch", "beats", "cacti", "camel", "chaos", "dubbo", "event", "feign", "flink", "flume", "geode", "gitea", "goods", "graph", "group", "habor", "hbase", "html5", "infra", "kafka", "label", "maven", "mesos", "micro", "minio", "nacos", "neo4j", "nerve", "nexus", "node1", "oauth", "oozie", "redis", "route", "scala", "spark", "sqoop", "stack", "store", "storm", "webui", "api-v1", "api-v2", "api-v3", "api-v4", "api-v5", "center", "client", "consul", "devops", "docker", "eureka", "falcon", "galaxy", "github", "gitlab", "goblin", "gradle", "group1", "hadoop", "harbor", "influx", "kibana", "lcinga", "logapi", "logger", "manage", "mobile", "nagios", "node01", "oauth2", "office", "pgraph", "portal", "ribbon", "router", "scribe", "search", "server", "sleuth", "spark1", "splunk", "spring", "stream", "syslog", "sysmon", "tracer", "triton", "tuning", "web-ui", "weblog", "zabbix", "zipkin", "airflow", "akumuli", "ansible", "bigdata", "breaker", "brogmon", "catalog", "circuit", "content", "control", "datadog", "diagram", "elastic", "eureka1", "fluentd", "gateway", "gemfire", "grafana", "hystrix", "invoker", "jenkins", "jupyter", "kinesis", "library", "logging", "manager", "meeting", "metrics", "monitor", "netdata", "netflix", "nodered", "payment", "pushapi", "recruit", "restapi", "restful", "rsyslog", "service", "storage", "tracing", "turbine", "webflow", "activemq", "actuator", "cadvisor", "collectd", "contract", "dataflow", "elkstack", "exporter", "filebeat", "graphite", "heapster", "influxdb", "librenms", "logstash", "marathon", "node-red", "opentsdb", "pipeline", "platform", "push-api", "rabbitmq", "schedule", "searcher", "tracking", "training", "analytics", "atlassian", "cassandra", "community", "dashboard", "developer", "discovery", "dockerhub", "dzzoffice", "elk-stack", "kubernete", "logsearch", "mapreduce", "office365", "openstack", "pagerduty", "serverset", "terraform", "websocket", "zookeeper", "clickhouse", "cloudwatch", "confluence", "dashboards", "datacenter", "dispatcher", "kube-state", "kubernetes", "management", "openfalcon", "prometheus", "servicelog", "skywalking", "usercenter", "data-center", "eureka-zuul", "kube-status", "loganalysis", "open-falcon", "opentracing", "pushgateway", "recruitment", "restful-api", "service-log", "serviceslog", "user-center", "alertmanager", "eureka-admin", "grafana-kong", "push-gateway", "services-log", "elasticsearch", "eureka-client", "eureka-server", "node-exporter", "kong-dashboard", "grafana-dashboard", "grafana-management"], @["1", "2", "3", "01", "02", "03", "v1", "v2", "v3"]]

proc seqToString(seq_string: seq[string], js: string=""): string =
  for i in low(seq_string)..high(seq_string):
    result = result & seq_string[i]
    if i != high(seq_string):
      result = result & js
  return result

proc tupleToSeq(tuples: tuple): seq[string] =
  for s in tuples.fields:
    result.add(s)
  return result

proc is_main_domain(domain: string): bool =
  let x = @["com", "gov", "cn", "org", "edu", "net"]
  if count(domain, '.') < 2:
    return true
  elif count(domain, '.') < 3 and domain.split('.')[^2] in x:
      return true
  else:
    return false


proc read_all_domains(input_file: string): seq[string] =
  var domains: seq[string] = @[]

  for line in lines input_file:
    domains.add(replace(line, " ", ""))
  
  result = sequtils.deduplicate(domains, isSorted=true)
  return result

#[
proc get_configuration(current_dir: string, mode: string): seq[seq[string]] =
  var
    config: Config
    regular_path = os.joinPath(current_dir, "rules", "regular.cfg")
    cfg_path = os.joinPath(current_dir, "rules", "predictor-" & mode & ".cfg")

  for cfg in [regular_path, cfg_path]:
    var
      pos: int
      f = streams.newFileStream(cfg, fmRead)
    if f != nil:
      var p: parsecfg.CfgParser
      parsecfg.open(p, f, cfg)
      while true:
        var e = next(p)
        case e.kind
        of cfgEof: break
        of cfgSectionStart:
          pos = find(Section, e.section)
        of cfgKeyValuePair:
          config[pos].add(e.key)
        of cfgOption:
          discard
        of cfgError:
          echo(e.msg)
      close(p)
    else:
      echo("[-] cannot open: " & cfg)
  
  return @config
]#

iterator awesome_factory(join_string: string, elements: seq[seq[string]], mix_join: string = ""): string =
  var element_num: int
  if elements.len >= 3:
    element_num = 3
  else:
    element_num = 2
  for length in 2..element_num:
    if length > elements.len: continue
    if length == 2:
      for x in combinations(elements, length):
        for y in product(x[0], x[1]):
          for z in permutations(tupleToSeq(y)):
            yield seqToString(z, join_string)
    elif length == 3:
      for x in combinations(elements, length):
        for y in product(x[0], x[1], x[2]):
          for z in permutations(tupleToSeq(y)):
            yield seqToString(z, join_string)
    else: quit()


proc name_filter(name: string, domain: string, prefix: string): string =
  var js_chunk: seq[string]
  if contains(name, '-'):
    for v1 in name.split('.'):
      for v2 in v1.split('-'):
        js_chunk.add(v2)
  else:
    js_chunk = name.split('.')

  var
    name_length = name.len
    js_chunk_length = js_chunk.len
  
  if js_chunk_length >= 3:
    # drop  aa.bb.cc/aa-bb-cc/aa-bb.cc/aa.bb-cc  too short name
    if name_length <= (js_chunk_length * 2 + js_chunk_length - 1):
      return ""
    # drop  aaaaaa-bbbbbb-cccccc  too long name
    if count(name, '-') >= js_chunk_length - 1 and name_length >= (js_chunk_length * 6 + js_chunk_length - 1):
      return ""
    # drop  aaaaaaaa./-bbbbbbbb./-cccccccc  too long name
    if name_length >= (js_chunk_length * 8 + js_chunk_length - 1):
      return ""
    
  if prefix.len > 0:
    if prefix in js_chunk:
      if js_chunk_length <= 3:
        return name & "." & domain[(prefix.len+1)..high(domain)]
    else:
      return name & "." & domain
  else:
    return name & "." & domain
  return ""


proc get_main_domain_similar_domain_names(domain: string, config: seq[seq[string]]): seq[string] =
  for one_list in config[0..10]:
    for item in one_list:
      result.add(item & "." & domain)

  var
    nf: string = ""
    small_lists = config[0..5]
  # small_lists.add(config[^1])

  for js in [".", "-"]:
    for name in awesome_factory(js, small_lists, ""):
      nf = name_filter(name, domain, "")
      if nf.len > 0:
        result.add(nf)

  for name in awesome_factory("-", small_lists, mix_join="."):
    nf = name_filter(name, domain, "")
    if nf.len > 0:
      result.add(nf)

  return result



proc get_normal_domain_similar_domain_names(domain: string, config: seq[seq[string]]): seq[string] =
  var 
    nf: string
    prefix: string = domain.split(".")[0]
    small_lists: seq[seq[string]]
  
  small_lists = config[0..5]
  small_lists.add(@[prefix])


  for js in [".", "-"]:
    for name in awesome_factory(js, small_lists, ""):
      nf = name_filter(name, domain, prefix)
      if nf.len > 0:
        result.add(nf)
  
  for name in awesome_factory("-", small_lists, mix_join="."):
    nf = name_filter(name, domain, prefix)
    if nf.len > 0:
      result.add(nf)

  return result

proc printer(predictor_mode: string, output_path: string, begin_time: float, count: int): bool =
  echo "[+] current mode: [" & predictor_mode & "]"
  echo "[+] A total of  : ", count, " lines"
  echo "[+] Store in    : " & output_path
  let cost_time: float = times.cpuTime() - begin_time
  echo "[+] Cost        : ", cost_time.formatFloat(ffDecimal, 4), " seconds"


when isMainModule:
  let begin_time = times.cpuTime()
  let ascii_banner = r"""
                  _   _
                 (.)_(.)
              _ (   _   ) _
             / \/`-----'\/ \
           __\ ( (     ) ) /__
           )   /\ \._./ /\   (
            )_/ /|\ . /|\ \_(     
            ,,,,,,,,,,,,,,,,,.   
         ,,,,,,,,,,.  .,,,,,,,,,,
         ,,,,    Dnp         ,,,.
          @@        .Nim      @@ 
           @@@@,#@@@@@@@@./@@@@  
            @@@@@@@@@@@@@@@@@%   
               .@@@@@@@@@@   
"""

  let p = newParser:
    help("A simple modernized enterprise domain name predictor and generator")
    option("-d", "--domain", default=some(""), help="single domain name")
    option("-f", "--file", default=some(""), help="domain names file path")
    option("-m", "--mode", default=some("default"), choices = @["default", "simple"], help="choose predictor mode: [default, simple]")
    option("-o", "--output", default=some(""), help="result output path")
    flag("-s", "--silent", help="eg: dnp -d qq.com -s | ksubdomain -verify -silent | httpx -title -content-length -status-code")
  
  let cmdline = os.commandLineParams()
  if cmdline.len <= 1:
    echo ascii_banner
    echo p.help
    quit()
  
  var
    args = p.parse(cmdline)
    input_file: string
    input_name = args.domain
    predictor_mode = args.mode
    silent_mode = args.silent

  let current_dir = os.getCurrentDir()
  var output_path = os.joinPath(current_dir, "results")
  if not silent_mode: discard os.existsOrCreateDir(output_path)

  if contains(args.file, '\\') or contains(args.file, '/'):
    input_file = args.file
  else:
    input_file = os.joinPath(current_dir, args.file)

  if args.output.len > 0:
    output_path = args.output
  else:
    if input_name.len > 0:
      output_path = os.joinPath(output_path, input_name & "-" & predictor_mode & ".txt")
    else:
      let fileSplit = os.splitFile(args.file)
      output_path = os.joinPath(output_path, fileSplit.name & "-" & predictor_mode & ".txt")
  
  if not silent_mode: echo ascii_banner
  
  # var config = get_configuration(current_dir, predictor_mode)
  var config: seq[seq[string]]
  if predictor_mode == "simple":
    config = config_simple
  else:
    config = config_default


  var
    count = 0
    file: File 
  
  if not silent_mode: file = open(output_path, fmWrite)

  if input_name.len > 0:
    var result: seq[string]
    if is_main_domain(input_name):
      result = get_main_domain_similar_domain_names(input_name, config)
    else:
      result = get_normal_domain_similar_domain_names(input_name, config)
    for i in result:
      if silent_mode: echo i
      else: file.writeLine(i)
      count += 1
  else:
    for ns in read_all_domains(input_file):
      if(is_main_domain(ns)):
        for i in get_main_domain_similar_domain_names(ns, config):
          if silent_mode: echo i
          else: file.writeLine(i)
          count += 1
      else:
        for i in get_normal_domain_similar_domain_names(ns, config):
          if silent_mode: echo i
          else: file.writeLine(i)
          count += 1
  
  if not silent_mode: 
    file.close()
    discard printer(predictor_mode, output_path, begin_time, count)