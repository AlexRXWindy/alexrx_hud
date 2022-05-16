--Edited por 'Alex_RX™#4718'
--Autor del codigo Medinaa#7364

ESX = exports.es_extended:getSharedObject()

RegisterServerEvent('mdn_hud:saveColor', function(color)
    local identifier = ESX.GetPlayerFromId(source).getIdentifier()
    MySQL.Async.execute('UPDATE users SET colorhud = @color WHERE identifier = @identifier', {
        ['@identifier'] = identifier,
        ['@color'] = color
    })
end)

ESX.RegisterServerCallback('mdn:getColor', function(source, cb)
    local identifier = ESX.GetPlayerFromId(source).getIdentifier()
    MySQL.Async.fetchAll('SELECT colorhud FROM users WHERE identifier = @identifier',  {
        ['@identifier'] = identifier
    }, function(result)
        cb(result[1].colorhud)
    end)
end)