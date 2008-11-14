use ExtUtils::MakeMaker;

WriteMakefile(
   NAME => 'LEOCHARRE::HTML::Text',
   VERSION_FROM => 'lib/LEOCHARRE/HTML/Text.pm',


   # gen /usr/bin/pmused by Fri Nov 14 15:58:38 EST 2008 
   PREREQ_PM => {
      'Carp'                              => '1',
      'Exporter'                          => '5',
      'File::Which'                       => '0.05',
      'HTML::Entities'                    => '1.29',
      'LEOCHARRE::CLI'                    => '1.19',
      'LEOCHARRE::DEBUG'                  => '1.12',
      'Smart::Comments'                   => '1',
      'Test::Simple'                      => '0',
   },


   EXE_FILES => [qw(bin/html2txt)],
);


