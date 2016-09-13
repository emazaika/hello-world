#!/usr/bin/perl

#use strict;
use Bio::EnsEMBL::Registry;
use Bio::EnsEMBL::Compara::DBSQL::DBAdaptor;
use Bio::AlignIO;
my $reg = "Bio::EnsEMBL::Registry";

print "Connect to DB\n";
$reg->load_registry_from_db(
    -host , "ensembldb.ensembl.org",
    -user , "anonymous"
);

my $comparadb= new Bio::EnsEMBL::Compara::DBSQL::DBAdaptor(
    -host   => "ensembldb.ensembl.org",
    -port   => 5306,
    -user   => "anonymous",
    -dbname => 'ensembl_compara_51',
);

print "Get Adaptors\n"; #(Species, Type of DB, Type of Object)
my $hg_adaptor = $reg->get_adaptor("human","core","Gene"); #what adaptors do I need to get to homology
my $familyA = $reg->get_adaptor("Multi", "compara", "Family");
my $seqmemberA = $reg->get_adaptor("Multi", "compara", "SeqMember");

print "Enter Gene ID \n";
my $gene_input = <STDIN>;
chomp($gene_input);

my $gene_member_adaptor = Bio::EnsEMBL::Registry->get_adaptor('Multi', 'compara', 'GeneMember');
my $gene_member = $gene_member_adaptor->fetch_by_stable_id($gene_input);

my $homology_adaptor = Bio::EnsEMBL::Registry->get_adaptor('Multi', 'compara', 'Homology');
my $homologies = $homology_adaptor->fetch_all_by_Member($gene_member);

my $n = 0;

foreach my $homology (@{$homologies}) {
		print $n," ", $homology->description," ", $homology->taxonomy_level,"\n";	
		$n = $n + 1;
		my $homology2 = $homologies->[$n];

		if (($n < 79) && ($n > 71)) {
		
		my $members = (@{$homology2->get_all_Members});
		foreach my $example (@{$members->taxon_id}) {
		print $example;

			foreach my $member (@{$homology2->get_all_Members}) {
					if ($member->taxon_id == 9606) {
						print (join " ", map { $member->$_ } qw(stable_id));
						print " ";
						print $member->taxon_id;
						print "\n";
						#print (join " ", map { $member->$_ } qw(perc_id perc_pos perc_cov));
						#print "\n";
					}
			}
		}
}

print "Which homology (enter number) \n";
my $homology_input = <STDIN>;
chomp($homology_input);

my $selectedhomology = $homologies->[$homology_input];
my $simplealign = $selectedhomology->get_SimpleAlign();
print $simplealign;

#my $alignIO = Bio::AlignIO->newFh(
#    -interleaved => 0,
#    -fh => \*STDOUT,
#    -format => "clustalw",
#    -idlength => 20);

print $simple_align;

#my $homology = $homologies->[0];
#print ref($homologies);
#print ref($homology);
#foreach my $member (@{$homology->get_all_Members}) {
#	print ref($member) . "\n";
#	print (join " ", map { $member->$_ } qw(stable_id taxon_id));
#	print "\n";
#	print (join " ", map { $member->$_ } qw(perc_id perc_pos perc_cov));
#	print "\n";
#}
	
#my $this_family = $familyA->fetch_by_stable_id('ENSFM00300000084926');
#print $fam;