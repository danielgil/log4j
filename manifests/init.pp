class log4j(
  $data = ''
){
  if ($data != ''){
    validate_hash($data)

    # Get the hash for each file
    $filtered_data = yaml_to_log4j($data)

    create_resources(log4j::configfile, $filtered_data[0])
    create_resources(log4j::logger, $filtered_data[1])
    create_resources(log4j::appenders::console, $filtered_data[2])
    create_resources(log4j::appenders::file, $filtered_data[3])
    create_resources(log4j::appenders::rollingfile, $filtered_data[4])

  }


}
