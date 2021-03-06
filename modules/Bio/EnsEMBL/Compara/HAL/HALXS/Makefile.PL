use 5.014002;
use ExtUtils::MakeMaker;

die "Environment variable PROGRESSIVE_CACTUS_DIR must be defined" unless ( $ENV{PROGRESSIVE_CACTUS_DIR} );
my $cactus = $ENV{PROGRESSIVE_CACTUS_DIR};

print "! Using progressiveCactus installation at $cactus\n";
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'HALXS',
    VERSION_FROM      => 'lib/HALXS.pm', # finds $VERSION
    PREREQ_PM         => {}, # e.g., Module::Name => 1.1
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/HALXS.pm', # retrieve abstract from module
       AUTHOR         => 'Carla Cummins <carlac@ebi.ac.uk>') : ()),
    DEFINE  => '', # e.g., '-DHAVE_SOMETHING'

    INC => "-I$cactus/submodules/hal/chain/inc/ -I$cactus/submodules/hal/maf/inc/",
    LIBS => [ "-L$cactus/submodules/hdf5/lib -L$cactus/submodules/hal/lib -L$cactus/submodules/sonLib/lib -lstdc++ -lhdf5 -lhdf5_cpp" ],
	MYEXTLIB => "$cactus/submodules/hal/lib/halChain.a $cactus/submodules/hal/lib/halLod.a $cactus/submodules/hal/lib/halLiftover.a $cactus/submodules/hal/lib/halLib.a $cactus/submodules/hal/lib/halMaf.a $cactus/submodules/sonLib/lib/sonLib.a",
    # Un-comment this if you add C files to link with later:
    # OBJECT            => '$(O_FILES)', # link all the C files too
);
