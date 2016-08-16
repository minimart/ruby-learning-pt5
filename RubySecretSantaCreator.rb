# Honoring a long standing tradition started by my wife's dad, my friends all play a Secret Santa
# game around Christmas time. We draw names and spend a week sneaking that person gifts and clues
# to our identity. On the last night of the game, we get together, have dinner, share stories, and,
#  most importantly, try to guess who our Secret Santa was. It's a crazily fun way to enjoy each
#  other's company during the holidays.
#
# To choose Santas, we use to draw names out of a hat. This system was tedious, prone to many
# "Wait, I got myself..." problems. This year, we made a change to the rules that further complicated
# picking and we knew the hat draw would not stand up to the challenge. Naturally, to solve this
# problem, I scripted the process. Since that turned out to be more interesting than I had expected,
#  I decided to share.
#
# This weeks Ruby Quiz is to implement a Secret Santa selection script.



class Array
        def random_member(&block)
            return select(&block).random_member if block
            return self[rand(size)]
        end
        def count(&block)
            return select(&block).size
        end
    end

    class String
        def clean_here_string
            indent = self[/^\s*/]
            return self.gsub(/^#{indent}/, "")
        end
    end

    class Person
        attr_reader :first, :family, :mail
        def initialize(first, family, mail)
            @first, @family, @mail = first, family, mail
        end
        def to_s() "#{first} #{family} <#{mail}>" end
    end

    class AssignSanta
        def initialize(persons)
            @persons = persons.dup
            @santas = persons.dup
            @families = persons.collect {|p| p.family}.uniq
            @families.each { |f|
                if santa_surplus(f) < 0
                    raise "No santa configuration possible"
            }
        end

        # Key function -- extra santas available for a family
        #        if this is negative -- no santa configuration is possible
        #        if this is 0 -- next santa must be assigned to this family
        def santa_surplus(family)
            return @santas.count {|s| s.family != family} -
                   @persons.count {|p| p.family == family}
        end

        def call
            while @persons.size() > 0
                family = @families.detect { |f|
                    santa_surplus(f)==0 and
                    @persons.count{|p| p.family == f} > 0
                }
                person = @persons.random_member { |p|
                    family == nil || p.family == family
                }
                santa = @santas.random_member{ |s|
                    s.family != person.family
                }
                yield(person, santa)
                @persons.delete(person)
                @santas.delete(santa)
            end
        end
    end
