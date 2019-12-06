car.bhp = 124;
car.colour = 'blue';
car.weight = 1280;
car.wheels = 4;
car.fuel_type = 'diesel';
car.model_name = 'ford focus';

car(2).bhp = 779;
car(2).colour = 'white';
car(2).weight = 2108;
car(2).wheels = 4;
car(2).fuel_type = 'electric';
car(2).model_name = 'tesla model s';

car(3).bhp = 3;
car(3).colour = 'black';
car(3).weight = 97;
car(3).wheels = 2;
car(3).fuel_type = 'petrol';
car(3).model_name = 'yamaha aerox 4';

car(:).pwr = p2wr(car(:).bhp, car(:).weight);


function pwr = p2wr(bhp,weight)
    pwr = bhp/weight;
end

function sorted = pwrSort(car)
