class VerifyReportService
    def initialize(params={})
        @reported = Survivor.where("id = ?", params[:reportedId]).last
        @reporter = Survivor.where("id = ?", params[:reporterId]).last
    end

    def charge
        verify_report
    end

    private

    def verify_report
        

        if @reporter and @reported
            if ReportList.where("reportedId = ? and reporterId = ?", @reported.id, @reporter.id).last
                2     
            else
                if  Survivor.where("id = ? and infected < 3", @reporter.id).count == 1
                    @suspect = Survivor.where("id = ?", @reported.id).last
                    @suspect.update(infected: @suspect.infected + 1)
                    1
                else
                    3
                end
            end
        else
            4
        end
    end
end