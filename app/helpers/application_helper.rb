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
  
  def average_stat_lines(stat_lines)
    stat_avg = StatLine.new
    stat_avg.fgm = avg_column(stat_lines, :fgm)
    stat_avg.fga = avg_column(stat_lines, :fga)
    #stat_avg.fgpct = avg_column(stat_lines, :fgpct)
    stat_avg.threem = avg_column(stat_lines, :threem)
    stat_avg.threea = avg_column(stat_lines, :threea)
    #stat_avg.threepct = avg_column(stat_lines, :threepct)
    stat_avg.ftm = avg_column(stat_lines, :ftm)
    stat_avg.fta = avg_column(stat_lines, :fta)
    #stat_avg.ftpct = avg_column(stat_lines, :ftpct)
    stat_avg.orb = avg_column(stat_lines, :orb)
    stat_avg.drb = avg_column(stat_lines, :drb)
    stat_avg.trb = avg_column(stat_lines, :trb)
    stat_avg.ast = avg_column(stat_lines, :ast)
    stat_avg.stl = avg_column(stat_lines, :stl)
    stat_avg.blk = avg_column(stat_lines, :blk)
    stat_avg.fl = avg_column(stat_lines, :fl)
    stat_avg.points = avg_column(stat_lines, :points)
    
    stat_avg.fgpct = stat_avg.fga != 0 ? stat_avg.fgm / stat_avg.fga : 0
    stat_avg.threepct = stat_avg.threea != 0 ? stat_avg.threem / stat_avg.threea : 0
    stat_avg.ftpct = stat_avg.fta != 0 ? stat_avg.ftm / stat_avg.fta : 0
    stat_avg
  end
  
  private
  def avg_column(stats, field)
    stats.size == 0 ? 0 : stats.map(&field).inject(:+).to_f / stats.size
  end
end
