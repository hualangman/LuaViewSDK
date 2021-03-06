--工具包引入
require "kit/lv_kit"
-- 变量定义
local s_width, s_height = System.screenSize()
local blockData, tableView

local loading = LoadingIndicator()
loading.size(200, 200)
loading.alignCenter()
loading.show()

tableView = RefreshTableView {
    Section = {
        SectionCount = 1, -- section数量
        RowCount = function(section)
            if (blockData) then
                return table:getn(blockData.model)
            else
                return 0
            end
        end
    },
    Cell = {
        Id = function(section, row) -- 指定section和row对应的Cell类型唯一识别号
            return "Cell1";
        end,
        Cell1 = {
            -- cell 具体样式
            Size = function(section, row)
                return 600
            end,
            Init = function(cell, section, row) -- 初始化cell
                cell.icon = Image();
                cell.title = Label();
                cell.info = Label();
            end,
            Layout = function(cell, section, row) -- cell复用时调用
                if (blockData) then
                    cell.icon.size(s_width, 400);
                    cell.icon.image('http:' .. blockData.model[row].materials["brandLogoUrl"]);
                    cell.title.frame(0, 400, 200, 50);
                    cell.title.text(blockData.model[row].materials["logoText"]);
                    cell.info.frame(500, 400, 600, 50)
                    cell.info.text(blockData.model[row].materials["brandDesc"])
                end
            end,
            Callback = {
                Click = function(cell, section, row) -- 用户点击了section和row
                    Toast("Click-Section " .. section .. ", Row " .. row);
                    System.gc();
                end,
                LongClick= function(cell, section, row)
                    Toast("LongClick-Section " .. section .. ", Row " .. row);
                    return true;
                end
            }
        }
    },
    Callback = {
        PullDown = function()
        -- 开始下拉刷新回调
            Timer(function()
                tableView.stopPullDownRefreshing()
            end).start(3000);
        end,
        PullUp = function()
        -- 开始上拉刷新回调
        end
    }
};


tableView.frame(0, 200, s_width, s_height - 200)
tableView.showScrollIndicator(false)


