package Dist::Zilla::Plugin::ReadmeMarkdownFromPod;

# ABSTRACT: Automatically convert POD to a README.mkdn for Dist::Zilla

use Moose;
use Moose::Autobox;

with 'Dist::Zilla::Role::InstallTool';

sub setup_installer
{
    my ($self, $arg) = @_;

    use Dist::Zilla::File::InMemory ();
    use Pod::Markdown ();

    my $parser = Pod::Markdown->new();
    $parser->parse_from_file($self->zilla->main_module->name);
    my $content = $parser->as_markdown();

    my $file =
      $self->zilla->files->grep( sub { $_->name =~ m{README.mkdn\z} } )->head;
    if ($file) {
        $file->content($content);
        $self->zilla->log("Override README.mkdn from [ReadmeMarkdownFromPod]");
    }
    else {
        $file = Dist::Zilla::File::InMemory->new(
            {
                content => $content,
                name    => 'README.mkdn',
            }
        );
        $self->add_file($file);
    }

    return;
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;
__END__

=head1 NAME

Dist::Zilla::Plugin::ReadmeMarkdownFromPod - Automatically convert POD to a README.mkdn for Dist::Zilla

=head1 SYNOPSIS

    # dist.ini
    [ReadmeMarkdownFromPod]

=head1 DESCRIPTION

Generate a README.mkdn from C<main_module> by L<Pod::Markdown>

The code is mostly a copy-paste of L<Dist::Zilla::Plugin::ReadmeFromPod>

=head1 SYNOPSIS

  use Dist::Zilla::Plugin::ReadmeMarkdownFromPod;

=head1 AUTHOR

Jacob Helwig E<lt>jhelwig at cpan.orgE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
