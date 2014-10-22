package Fey::ORM::Mock::Recorder;

use strict;
use warnings;

use Fey::ORM::Mock::Action;

use Moose;

has '_actions' =>
    ( is      => 'ro',
      isa     => 'HashRef[ArrayRef[Fey::ORM::Mock::Action]]',
      default => sub { {} },
    );


sub record_action
{
    my $self = shift;

    my $action = Fey::ORM::Mock::Action->new_action(@_);

    $self->_actions()->{ $action->class() } ||= [];
    push @{ $self->_actions()->{ $action->class() } }, $action;

    return;
}

sub actions_for_class
{
    my $self  = shift;
    my $class = shift;

    return @{ $self->_actions()->{$class} || [] };
}

sub clear_class
{
    my $self  = shift;
    my $class = shift;

    $self->_actions()->{$class} = [];
}

sub clear_all
{
    my $self = shift;

    for my $class ( keys %{ $self->_actions() } )
    {
        $self->clear_class($class);
    }
}

no Moose;

__PACKAGE__->meta()->make_immutable();

1;

__END__

=pod

=head1 NAME

Fey::ORM::Mock::Recorder - Records the history of changes for a class

=head1 DESCRIPTION

This object is used to store a record of the changes for each class.

=head1 METHODS

This class provides the following methods:

=head2 Fey::ORM::Mock::Recorder->new()

Returns a new recorder object.

=head2 $recorder->record_action(...)

This method takes a set of parameters which will be passed directly to
C<< Fey::ORM::Mock::Action->new_action() >>. Then it stores the action.

=head2 $recorder->actions_for_class($class)

Given a class name, this returns a list of stored actions for that
class, from least to most recent.

=head2 $recorder->clear_class($class)

Clears the record of actions for the class

=head2 $recorder->clear_all()

Clears the records for all classes.

=head1 AUTHOR

Dave Rolsky, C<< <autarch@urth.org> >>

=head1 COPYRIGHT & LICENSE

Copyright 2008 Dave Rolsky, All Rights Reserved.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
