=head1 LICENSE

  Copyright (c) 1999-2014 The European Bioinformatics Institute and
  Genome Research Limited.  All rights reserved.

  This software is distributed under a modified Apache license.
  For license details, please see

    http://www.ensembl.org/info/about/code_licence.html

=head1 CONTACT

  Please email comments or questions to the public Ensembl
  developers list at <http://lists.ensembl.org/mailman/listinfo/dev>.

  Questions may also be sent to the Ensembl help desk at
  <http://www.ensembl.org/Help/Contact>.

=head1 NAME

Bio::EnsEMBL::Compara::RunnableDB::DumpMultiAlign::MafReadme

=head1 SYNOPSIS

This RunnableDB module is part of the DumpMultiAlign pipeline.

=head1 DESCRIPTION

This RunnableDB module generates a general README.{maf} file and a specific README for the pairwise alignment being dumped

=head1 AUTHOR

ckong

=cut

package Bio::EnsEMBL::Compara::RunnableDB::DumpMultiAlign::MafReadme;

use strict;
use warnings;

use base ('Bio::EnsEMBL::Hive::Process');

sub run {
    my ($self)  = @_;

    my $export_dir = $self->param_required('export_dir');
    my $readme     = $export_dir."/README.txt";
    my $data;

    open  $data,">","$readme" or die $!;
    print $data "This directory contains the pairwise alignments generated by the EnsemblGenomes team.\n";
    print $data "There is 1 TAR archive per alignment, which contains the alignments in\n";
    print $data "(gzipped) MAF format (https://cgwb.nci.nih.gov/FAQ/FAQformat.html#format5).\n";
    print $data "\n";
    print $data "The first species is always the reference.\n";
    close($data);

}

1;
