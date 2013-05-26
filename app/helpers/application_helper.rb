module ApplicationHelper
  def total_stat_lines(stat_lines)
    stat_totals = stat_lines.inject(StatLine.new) do |total, stat_line|
      total.fgm += stat_line.fgm
      total.fga += stat_line.fga
      total.twom += stat_line.twom
      total.twoa += stat_line.twoa
      total.threem += stat_line.threem
      total.threea += stat_line.threea
      total.ftm += stat_line.ftm
      total.fta += stat_line.fta
      total.orb += stat_line.orb
      total.drb += stat_line.drb
      total.ast += stat_line.ast
      total.stl += stat_line.stl
      total.blk += stat_line.blk
      total.fl += stat_line.fl
      total.to += stat_line.to
      total
    end
    stat_totals.calc_percentages
    stat_totals
  end
end
