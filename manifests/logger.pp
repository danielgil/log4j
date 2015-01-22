define log4j::appender($name, $path, $level){

  augeas {$name:
    incl    =>  $path,
    context =>  '/files/tmp/foo.xml/foo',
    lens    => 'Xml.lns',
    changes => [
      "set Configuration/Loggers/Logger/#attribute#name $name",
    ]
  }


}