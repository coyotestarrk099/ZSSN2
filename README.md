# README API ZSSN

## Description

The world as we know it has fallen into an apocalyptic scenario. A laboratory-made virus is transforming human beings and animals into zombies, hungry for fresh flesh.

My name is **Lori Grimes**, an AI responsible for managing the Survivor Social Network, where other survivors can be found, can exchange their resources in a manner that respects the laws of the new apocalyptic world, contributes to maintaining the remnants of society, reporting new cases of infected, and have updated world details, new features like stories coming soon.

## Configuration

`gem update --system`

`bundle install`

## Database

`rails db:create`

after,

`rails db:migrate`

## Tests

## Get Started

`rails s`

### See All routes:

`rake routes`

### Server Listening:

`http://localhost:3000/`

## EndPoints

### Survivor

| Method  | URL         | Body  | Return             | Description                                    |
| ------- | ----------- | ----  | ------------------ | ---------------------------------------------- |
| **GET** | `/survivors` |              | Show all survivors | Endpoint that displays data from all survivors |
| **GET** | `/survivors/:id` |           | Show survivor data | Endpoint that displays data from a survivor    |
| **POST** | `/survivors` | SurvivorBody* | Created new survivors | Endpoint that displays data from the new added survivor |
| **PATCH** | `/survivors_location/:id` |  LocationBody** | Update survivor location | Endpoint that displays data from updated survivor    |
| **POST** | `/survivors_trade/:id` |   TradeBody***           | Show traders | Endpoint that displays data from survivors that make the trade |
| **GET** | `/survivors_zombie` |           | Show the infecteds percentage | Endpoint that displays data from a percentage of infected survivors     |
| **GET** | `/survivors_number` |              | Show the no infecteds percentage | Endpoint that displays from a percentage of infected survivors |
| **GET** | `/survivors_lost` |           | Show points lost because of infected survivor | Endpoint that displays data from resources points lost because of infected survivor    |
| **GET** | `/survivors_report` |           | Show average amount of each kind of resource by survivor | Endpoint that displays data from average amount of each kind of resource by survivor    |


<dt></summary>
<details>
<summary>SurvivorBody*</summary>

```
    {
    "survivor": {
        "name": "Ana NotabitZombie",
        "age": 20,
        "gender": "female",
        "latitude": 28.9,
        "longitude": -13.87,
        "water_amount": 1,
		"ammunition_amount": 1,
		"medication_amount": 1,
		"food_amount": 1
    }
}
```
</details></dt>

<dt></summary>
<details>
<summary>LocationBody**</summary>

```
    {
    "survivor": {
        "latitude": -12.9,
        "longitude": -12.87
    }
}
}
```
</details></dt>

<dt></summary>
<details>
<summary>TradeBody***</summary>
```
    {
    "trade": {
        "survivor_id": 1,
        "my_items": {
        	"food": 1,
        	"ammunition": 0,
        	"water": 0,
        	"medication": 0
        },
	    "friend_items": {
	    	"food": 0,
        	"ammunition": 1,
        	"water": 0,
        	"medication": 1
        }
    }
}
}
```
</details></dt>

### ReportList

| Method  | URL         | Body  | Return             | Description                                    |
| ------- | ----------- | ----  | ------------------ | ---------------------------------------------- |
| **GET** | `/report_lists` |             | Show all infection reports | Endpoint that displays data from all infection reports |
| **POST** | `/report_lists` |  ReportBody*  | Create a infection report | Endpoint that displays data from a infection report    |

<dt></summary>
<details>
<summary>ReportBody*</summary>

```
    {
    "report_list": {
        "reportedId": 1,
        "reporterId": 3
    }
}

```
</details></dt>

* ...
