#you may distribute this module under the same terms as perl itself
#
# POD documentation - main docs before the code

=pod 

=head1 NAME

Bio::EnsEMBL::Compara::RunnableDB::MakeNTSpeciesTree::PhylofitFactory

=cut

=head1 SYNOPSIS

=cut



package Bio::EnsEMBL::Compara::RunnableDB::MakeNTSpeciesTree::PhylofitFactory;

use strict;
use Bio::EnsEMBL::Registry;
use Bio::EnsEMBL::Compara::DBSQL::DBAdaptor;
use Data::Dumper;

use base('Bio::EnsEMBL::Compara::RunnableDB::BaseRunnable');

sub fetch_input {
 my $self = shift @_;
 
my $prev_compara_dba = new Bio::EnsEMBL::Compara::DBSQL::DBAdaptor( 
 %{ $self->param('previous_compara_db') } );


 my $gab_a = $prev_compara_dba->get_GenomicAlignBlockAdaptor;

 my $sp_tree_a = $prev_compara_dba->get_SpeciesTreeAdaptor;

 my @genomic_align_block_ids;

 my $mlss_id = $self->param('msa_mlssid');

 my $sql1 = "SELECT COUNT(*) FROM species_set ss ". 
            "INNER JOIN method_link_species_set ".
            "mlss ON mlss.species_set_id = ss.species_set_id ". 
            "WHERE mlss.method_link_species_set_id = ?";

 my $sth1 = $gab_a->dbc->prepare("$sql1");

 $sth1->execute("$mlss_id");

 my $count = $sth1->fetchall_arrayref()->[0]->[0];
 
 # only use alignments with a reasonable number of species
 my $sql2 = "SELECT gab.genomic_align_block_id 
            FROM genomic_align_block gab 
            INNER JOIN genomic_align ga ON
            ga.genomic_align_block_id = gab.genomic_align_block_id 
            INNER JOIN dnafrag df ON df.dnafrag_id = ga.dnafrag_id
            WHERE ga.method_link_species_set_id = ? GROUP BY 
            gab.genomic_align_block_id HAVING COUNT(distinct(df.genome_db_id)) = ?";
 
 my $sth2 = $gab_a->dbc->prepare("$sql2");

 $sth2->execute($mlss_id, $count);
 while(my $genomic_align_block_id = $sth2->fetchrow_array){
  my $genomic_align_block = $gab_a->fetch_by_dbID($genomic_align_block_id);
   # if the alignments consist of ancestral sequences - skip these 
   next if $genomic_align_block->genomic_align_array->[0]->dnafrag->genome_db->name eq "ancestral_sequences";
   push @genomic_align_block_ids, { 'block_id' => $genomic_align_block->dbID, 'tree_mlss_id' => $mlss_id};
 }

 $self->param('gab_ids', \@genomic_align_block_ids);
}

sub write_output {
 my $self = shift @_;
 $self->dataflow_output_id($self->param('gab_ids'), 2); 
}

1;