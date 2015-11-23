class log4j (
  $data = {},
){

  validate_hash($data)

  create_resources(log4j::configfile, $data)
}
