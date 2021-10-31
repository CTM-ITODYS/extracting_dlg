#!/usr/bin/perl
# ***********************
# *  clustering_dlg.pl  *
# ***********************
#
# usage: clustering_dlg.pl 
#
# The goal of this software is to extract the 10 first clustered structures of autodock
# output files. These ones must have the dlg extension. An output file containing precious
# information (energy and cluster) is also generated.
#
$| = 1;
use strict;
#use Math::Trig;
#-----------------------------------------------------------------------------------------------------------------------------
# Get the input arguments and declarations
#
my $nb_fich_dlg=0;
my $pose=0;
my $rep="";
my $motif="";
my $motif1="";
my $motif2="";
my $nom="";
my $motif_entre_cluster="CLUSTERING HISTOGRAM";
my $motif_entre="USER    Cluster Rank = ";
my $motif_sort ="TER";
my $test_extract=233;
my $cond=23;
my $option1=20;
my $i=0;
my $extract=0;
my $ligne=0;
my $fichier_pdb="";
my $occur=0;
my $cond=0;
#
# Interface, presentation   Index
#
system ("clear");
print "\n\nHi\n";
print "This software extract all first 10 Autodock pose from output files (dlg).\n";
#
# Generating list_dlg.txt and Reports_DLG.txt files 
#
{
  system("ls -1 *.dlg > list_dlg.txt");
  open (FICH,"< list_dlg.txt");
  open (FOUT,"> temp_Reports_DLG.txt");
  while ($nom=<FICH>){ $nb_fich_dlg=$nb_fich_dlg+1; }
  printf ("\nOn this directory you have %d dlg files\n",$nb_fich_dlg);
}
#
# Opening all file and generating the pdbs and report
#
for ($pose=1;$pose<11;$pose++)
{
   $nb_fich_dlg=0;
   open (FICH,"<list_dlg.txt")|| die ("Error you don't have list_dlg.txt") ;
   while ($nom=<FICH>)
   {
     chop($nom);
     $option1=21;
     $nb_fich_dlg=$nb_fich_dlg+1;
     #printf ("\nFile number %d name :  %s\n\n",$nb_fich_dlg,$nom);
     open (FICHDLG,"<$nom")|| die ("Error opening $nom");
     while ($ligne=<FICHDLG>)
     {
        $motif=substr($ligne,1,20);
        if( $motif eq $motif_entre_cluster)
		{
			$option1=1;
			if ($pose == 1)
		   {
				print FOUT "\n============================================================\n";
				print FOUT "File: $nom \n";
		   }
		}
        if($option1<20)
         {
           $option1=$option1+1;
		   if ($pose == 1)
		   {
			   print FOUT "$ligne";
		   }
         }
        if($option1==20)
         {
          $extract=$pose;
          $option1=$option1+1;
         }    
     }
     #print "\n extraction...";
     $fichier_pdb=$nom."pose".$pose;
     $fichier_pdb=~ s/(.dlg)+//;
     open (FSOR,">$fichier_pdb.pdb");
     $occur=0;
     $cond=0;
     open (FICHDLG,"<$nom")|| die ("Error you don't have liste_dlg.txt") ;
     while ($ligne=<FICHDLG>)
     {
        #print "$ligne"; 
        $motif1=substr($ligne,0,23);
        $motif2=substr($ligne,0,3);
        if ($motif1 eq $motif_entre)
        {
           $test_extract=substr($ligne,23,2);
           if ($test_extract==$extract)
           {
              $cond=1;
           }
        }
        if ($cond == 1)
        {
          if ($motif2 eq $motif_sort)
          {
             $cond=0;
             $occur=1;
          }
        if ($occur == 0)
        {
         print FSOR "$ligne";
        } 
     }    
   } 
     
 }
}
close(FOUT);
close(FICH);
close(FICHDLG);
system("egrep -v \"CLUSTERING HISTOGRAM\" temp_Reports_DLG.txt > tt_Reports_DLG.txt");
system("egrep -v \"	____________________\" tt_Reports_DLG.txt > Reports_DLG.txt");
system("rm temp_Reports_DLG.txt tt_Reports_DLG.txt list_dlg.txt");
print "\n Bye.... \n";

