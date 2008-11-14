package LEOCHARRE::HTML::Text;
use Carp;
use strict;
use Exporter;
use vars qw($VERSION @EXPORT_OK %EXPORT_TAGS @ISA);
@ISA = qw/Exporter/;
@EXPORT_OK = qw/html2txt/;
use LEOCHARRE::DEBUG;
$VERSION = sprintf "%d.%02d", q$Revision: 1.3 $ =~ /(\d+)/g;





# proc api

sub html2txt {
   my $arg = shift;
   $arg or carp("Missing argument.") and return;

   debug("arg $arg");
   my $_type = _source_type($arg) 
      or carp("Don't understand the source type, is it html, url, or file???") and return;
   
   debug("arg $arg, type:$_type \n");

   my $html =   
      $_type eq 'file' ? _slurp_file($arg) :
         $_type eq 'url'  ? _slurp_url($arg)  :
         $_type eq 'html' ? $arg : ( warn("Don't know what to do with arg '$arg'\n") and return );

   $html or warn("Could not get html.\n")  and return;

   debug("length ".length($html));
   
   my $text = _generate_text_from_html($html) or warn("Could not generate text from html.\n") and return;
   $text;
}



# subs


sub _source_type {
   my $arg = shift;
   -f $arg and return 'file';
   $arg=~/^http|\.com$|\.net$|\.org$/ and $arg!~/\s/ and ( length $arg < 300 ) and return 'url';
   $arg=~/\</ and return 'html';
   return;
}

sub _slurp_url {
   my $arg = shift;
   require File::Which;
   my $bin = File::Which::which('wget') or die("Missing 'wget' from system.\n");

   my $out = `$bin -q -O - '$arg'`;
   $? and carp("Something went wrong with wget, $?\n") and return;
   $out or carp("It seems '$arg' produces no output.\n") and return;
   return $out;
}

sub _slurp_file {
   my $arg = shift;
   local $/;
   open(FILE,'<',$arg) or die("Can't open $arg, $!\n");
   my $out = <FILE>;
   close FILE;
   $out or carp("It seems '$arg' produces no output.\n") and return;
   return $out;
}





# at this point we should be sure already that the argument is html
sub _generate_text_from_html {
   my $html = shift;

   debug(length $html);
   # rip out scripts
   require LEOCHARRE::HTML::Rip;
   $html = LEOCHARRE::HTML::Rip::rip_tag($html,'script');
   debug(length $html);   
   $html = LEOCHARRE::HTML::Rip::rip_tag($html,'style');
   debug(length $html);


   require HTML::Entities;

   $html= HTML::Entities::decode($html);

   #   $html=~/<a href="([^])
   $html=~s/<\/p>/\n/isg;
   $html=~s/<[^<>]+>/ /sg;
   $html=~s/ {2,}/ /g;   

   $html=~s/(\w)\s+(\w)/$1 $2/sig;

   $html=~s/\n[\t ]{2,}/\n   /g;
   $html=~s/\n /\n/g;
   $html=~s/[\n\r]{2,}/\n/g;
   $html=~s/^\s+|\s+$//g;


   $html=~s/\s{5,}/\n\n/gs;

   $html;
}






1;


__END__

=pod

=head1 NAME

LEOCHARRE::HTML::Text - turn html to text

=head1 DESCRIPTION

This converts html code into text.

=head2 Namespace

It resides under my namespace because I am not so presumptuous as to think I am the most 
qualified person to write this.
But I am qualified.
So here.

=head1 SUBROUTINES

Not exported by default



=head2 html2txt()

Argument is url, html code, or path to file on disk.
Returns text.

=head1 OO API

=head2 SYNOPSIS

   use LEOCHARRE::HTML::Text;

   my $o = LEOCHARRE::HTML::Text->new($url);
   my $o = LEOCHARRE::HTML::Text->new($path);
   my $o = LEOCHARRE::HTML::Text->new($html);

   my $html_original    = $o->html_original;
   my $html_cleaned     = $o->html_cleaned;
   my $html_source_type = $o->html_source_type;

